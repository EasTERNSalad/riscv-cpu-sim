`timescale 1ns/1ps
module cpu_top (
    input clk,
    input reset
);
   // CYCLES
   reg [31:0] cycles = 0;
   always @(posedge clk)
        cycles <= cycles + 1;

   // IF STAGE signals
   wire [31:0] pc;
   wire [31:0] next_pc;
   wire [31:0] instr;

   assign next_pc = pc + 4;

   // hazard / stall 
   wire stall;

   wire [31:0] pc_for_ifid = stall ? pc : next_pc;

   // PC register module drives pc 
   // pass next_pc
   pc PC(.clk(clk), .reset(reset), .next_pc(next_pc), .pc(pc));

   // instruction memory reads from pc (fetch)
   imem IMEM(.addr(pc), .instr(instr));

   // IF/ID pipeline register: feed the pc_for_ifid and instr
   wire [31:0] pc_ifid, instr_ifid;
   if_id IFID(.clk(clk), .reset(reset), .pc_in(pc_for_ifid), .instr_in(instr), .pc_out(pc_ifid), .instr_out(instr_ifid));

    // HAZARD: load-use detection
    // rd_indec and MemRead_indec will be produced by ID/EX pipeline so declare them earlier (they are wires below)
    // wire load_use_hazard = (MemRead_indec && ((rd_indec == rs1) || (rd_indec == rs2)));
    // stall assigned below after those wires exist; keep this here as forward logic

   // ID stage decode fields 
   wire [6:0] opcode = instr_ifid[6:0]; //7 bits for control
   wire [4:0] rs1 = instr_ifid[19:15];
   wire [4:0] rs2 = instr_ifid[24:20];
   wire [4:0] rd  = instr_ifid[11:7];

   // REGISTER FILE
   wire [31:0] rs1_data, rs2_data;

   // WB signals 
   wire RegWrite_wb;
   wire [4:0] rd_wb;
   wire [31:0] wb_data;

   regfile RF(.clk(clk), .we(RegWrite_wb), .rs1(rs1), .rs2(rs2), .rd(rd_wb), .wd(wb_data), .rd1(rs1_data), .rd2(rs2_data));

   // CONTROL + IMM_GEN
   wire RegWrite, MemRead, MemWrite, MemToReg, ALUSrc;
   wire [1:0] ALUOp;
   control CTRL(.opcode(opcode), .RegWrite(RegWrite), .MemRead(MemRead), .MemToReg(MemToReg), .ALUSrc(ALUSrc), .ALUOp(ALUOp));
   wire [31:0] imm;
   imm_gen IMM(.instr(instr_ifid), .imm(imm));

   // ID/EX pipeline wires
   wire [31:0] pc_indec, rs1_data_indec, rs2_data_indec, imm_indec;
   wire [4:0] rs1_indec, rs2_indec, rd_indec;
   wire RegWrite_indec, MemRead_indec, MemWrite_indec, MemToReg_indec, ALUSrc_indec;

   // load-use hazard detection 
   wire load_use_hazard = (MemRead_indec &&
                          ((rd_indec == rs1) || (rd_indec == rs2)));

   // stall control
   assign stall = load_use_hazard;

   // ID/EX: freeze control fields on stall 
   id_ex IDEX(.clk(clk), .reset(reset),
              .RegWrite_in(stall ? 1'b0 : RegWrite), .MemRead_in(stall ? 1'b0 : MemRead), .MemWrite_in(stall ? 1'b0 : MemWrite), .MemToReg_in(stall ? 1'b0 : MemToReg), .ALUSrc_in(stall ? 1'b0 : ALUSrc),
              .pc_in(stall ? 32'b0 : pc_ifid), .rs1_data_in(stall ? 32'b0 : rs1_data), .rs2_data_in(stall ? 32'b0 : rs2_data), .rs1_in(stall ? 5'b0 : rs1), .rs2_in(stall ? 5'b0 : rs2), .rd_in(stall ? 5'b0 : rd), .imm_in(stall ? 32'b0 : imm),
              .RegWrite(RegWrite_indec), .MemRead(MemRead_indec), .MemWrite(MemWrite_indec), .MemToReg(MemToReg_indec), .ALUSrc(ALUSrc_indec),
              .pc(pc_indec), .rs1_data(rs1_data_indec), .rs2_data(rs2_data_indec), .rs1(rs1_indec), .rs2(rs2_indec), .rd(rd_indec), .imm(imm_indec)
              );

    // EX stage forwarding
    wire forwardA_exmem = (RegWrite_exmem && (rd_exmem != 5'b0) && (rd_exmem == rs1_indec));
    wire forwardB_exmem = (RegWrite_exmem && (rd_exmem != 5'b0) && (rd_exmem == rs2_indec));

    wire forwardA_memwb = (RegWrite_memwb && (rd_memwb != 5'b0) && (rd_memwb == rs1_indec));
    wire forwardB_memwb = (RegWrite_memwb && (rd_memwb != 5'b0) && (rd_memwb == rs2_indec));

    // select forwarded operands for rs1
    wire [31:0] alu_a = forwardA_exmem ? alu_exmem :
                    (forwardA_memwb ? wb_data : rs1_data_indec);

    // select forwarded operands for rs2 
    wire [31:0] rs2_for_alu = forwardB_exmem ? alu_exmem :
                          (forwardB_memwb ? wb_data : rs2_data_indec);

    // final alu_b depends on ALUSrc
    wire [31:0] alu_b = ALUSrc_indec ? imm_indec : rs2_for_alu;
    wire [2:0] alu_ctrl; // driven by alu_control module
    wire [31:0] alu_res;
    wire alu_zero;
    wire [2:0] funct3 = instr_ifid[14:12];
    wire funct7_7 = instr_ifid[30];

    alu_control ALU_CTRL(.ALUOp(ALUOp), .funct3(funct3), .funct7_7(funct7_7), .alu_ctrl(alu_ctrl));

    alu ALU(
      .a(alu_a),
      .b(alu_b),
      .alu_ctrl(alu_ctrl),
      .result(alu_res),
      .zero(alu_zero)
    );

    // EX/MEM
    wire [31:0] alu_exmem, rs2_exmem;
    wire [4:0] rd_exmem;
    wire RegWrite_exmem, MemRead_exmem, MemWrite_exmem, MemToReg_exmem;

    ex_mem EXMEM(
      .clk(clk), .reset(reset),
      .RegWrite_in(RegWrite_indec), .MemRead_in(MemRead_indec), .MemWrite_in(MemWrite_indec), .MemToReg_in(MemToReg_indec),
      .alu_result_in(alu_res), .rs2_data_in(rs2_data_indec), .rd_in(rd_indec),
      .RegWrite(RegWrite_exmem), .MemRead(MemRead_exmem), .MemWrite(MemWrite_exmem), .MemToReg(MemToReg_exmem),
      .alu_result(alu_exmem), .rs2_data(rs2_exmem), .rd(rd_exmem)
    );

    // MEM
    wire [31:0] mem_read_data;
    dmem DM(.clk(clk), .MemRead(MemRead_exmem), .MemWrite(MemWrite_exmem), .addr(alu_exmem), .wdata(rs2_exmem), .rdata(mem_read_data));

    // MEM/WB
    wire RegWrite_memwb, MemToReg_memwb;
    wire [31:0] read_mem_memwb, alu_memwb;
    wire [4:0] rd_memwb;
    mem_wb MEMWB(
      .clk(clk),
      .reset(reset),
      .RegWrite_in(RegWrite_exmem), .MemToReg_in(MemToReg_exmem), .read_data_in(mem_read_data), .alu_result_in(alu_exmem), .rd_in(rd_exmem),
      .RegWrite(RegWrite_memwb), .MemToReg(MemToReg_memwb), .read_data(read_mem_memwb), .alu_result(alu_memwb), .rd(rd_memwb)
    );

    // WB: choose --> mem or alu result, write to regfile
    assign wb_data = (MemToReg_memwb) ? read_mem_memwb : alu_memwb;
    assign RegWrite_wb = RegWrite_memwb;
    assign rd_wb = rd_memwb;

endmodule
