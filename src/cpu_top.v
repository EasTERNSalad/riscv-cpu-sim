`timescale 1ns/1ps
module cpu_top (
    input clk,
    input reset
);
   //CYCLES
   reg [31:0] cycles = 0;
   always @(posedge clk)
        cycles <= cycles + 1;

   //IFSTAGE
   wire [31:0] pc, next_pc, instr;
   assign next_pc = pc + 4;

   pc PC(.clk(clk), .reset(reset), .next_pc(next_pc), .pc(pc));
   imem IMEM(.addr(pc), .instr(instr));

   //IF/ID
   wire [31:0] pc_ifid, instr_ifid;
   if_id IFID(.clk(clk), .reset(reset), .pc_in(pc), .instr_in(instr), .pc_out(pc_ifid), .instr_out(instr_ifid));

   //ID
   wire [6:0] opcode = instr_ifid[6:0]; //7bits for control
   wire [4:0] rs1 = instr_ifid[19:15];
   wire [4:0] rs2 = instr_ifid[24:20];
   wire [4:0] rd = instr_ifid[11:7];

   //REGISTER FILE
   wire [31:0] rs1_data, rs2_data;

   //WBSIGNALS
   wire RegWrite_wb;
   wire [4:0] rd_wb;
   wire [31:0] wb_data;

   regfile RF(.clk(clk), .we(RegWrite_wb), .rs1(rs1), .rs2(rs2), .rd(rd_wb), .wd(wb_data), .rd1(rs1_data), .rd2(rs2_data));

   //CONTROL + IMM_GEN
   wire RegWrite, MemRead, MemWrite, MemToReg, ALUSrc;
   wire [1:0] ALUOp;
   control CTRL(.opcode(opcode), .RegWrite(RegWrite), .MemRead(MemRead), .MemToReg(MemToReg), .ALUSrc(ALUSrc), .ALUOp(ALUOp));
   wire [31:0] imm;
   imm_gen IMM(.instr(instr_ifid), .imm(imm));

   //ID/EX
   wire [31:0] pc_indec, rs1_data_indec, rs2_data_indec, imm_indec;
   wire [4:0] rs1_indec, rs2_indec, rd_indec;
   wire RegWrite_indec, MemRead_indec, MemWrite_indec, MemToReg_indec, ALUSrc_indec;

   id_ex IDEX(.clk(clk), .reset(reset),
              .RegWrite_in(RegWrite), .MemRead_in(MemRead), .MemWrite_in(MemWrite), .MemToReg_in(MemToReg), .ALUSrc_in(ALUSrc),
              .pc_in(pc_ifid), .rs1_data_in(rs1_data), .rs2_data_in(rs2_data), .rs1_in(rs1), .rs2_in(rs2), .rd_in(rd), .imm_in(imm),
              .RegWrite(RegWrite_indec), .MemRead(MemRead_indec), .MemWrite(MemWrite_indec), .MemToReg(MemToReg_indec), .ALUSrc(ALUSrc_indec),
              .pc(pc_indec), .rs1_data(rs1_data_indec), .rs2_data(rs2_data_indec), .rs1(rs1_indec), .rs2(rs2_indec), .rd(rd_indec), .imm(imm_indec)
              );

    //EX simple
    wire [31:0] alu_b = ALUSrc_indec ? imm_indec : rs2_indec;
    wire [2:0] alu_ctrl = 3'b000;
    wire [31:0] alu_res;
    wire alu_zero;
    //demo asume alu_cntrl 000(ADD)
    alu ALU(.a(rs1_data_indec), .b(alu_b), .alu_ctrl(3'b000), .result(alu_res), .zero(alu_zero));

    //EX/MEM
    wire [31:0] alu_exmem, rs2_exmem;
    wire [4:0] rd_exmem;
    wire RegWrite_exmem, MemRead_exmem, MemWrite_exmem, MemToReg_exmem;

    ex_mem EXMEM(
    .clk(clk),.reset(reset),
    .RegWrite_in(RegWrite_indec), .MemRead_in(MemRead_indec), .MemWrite_in(MemWrite_indec), .MemToReg_in(MemToReg_indec),

    .alu_result_in(alu_res), .rs2_data_in(rs2_data_indec), .rd_in(rd_indec),

    .RegWrite(RegWrite_exmem), .MemRead(MemRead_exmem), .MemWrite(MemWrite_exmem), .MemToReg(MemToReg_exmem),

    .alu_result(alu_exmem), .rs2_data(rs2_exmem), .rd(rd_exmem)
);

    
    //MEM
    wire [31:0] mem_read_data;
    dmem DM(.clk(clk), .MemRead(MemRead_exmem), .MemWrite(MemWrite_exmem), .addr(alu_exmem), .wdata(rs2_exmem), .rdata(mem_read_data));

    //MEM/WB
    wire RegWrite_memwb, MemToReg_memwb;
    wire [31:0] read_mem_memwb, alu_memwb;
    wire [4:0] rd_memwb;
   mem_wb MEMWB(
    .clk(clk), .reset(reset),

    .RegWrite_in(RegWrite_exmem), .MemToReg_in(MemToReg_exmem), .read_data_in(mem_read_data), .alu_result_in(alu_exmem), .rd_in(rd_exmem),

    .read_data(read_mem_memwb), .alu_result(alu_memwb), .rd(rd_memwb)
);
    
    //WB: choose --> mem or alu result, write to regfile
    assign wb_data = (MemToReg_memwb) ? read_mem_memwb : alu_memwb;
    assign RegWrite_wb = RegWrite_memwb;
    assign rd_wb = rd_memwb;

endmodule