module id_ex (
    input clk,
    input reset,

    input RegWrite_in,
    input MemRead_in,
    input MemWrite_in,
    input MemToReg_in,
    input ALUSrc_in,

    input [31:0] pc_in,
    input [31:0] rs1_data_in,
    input [31:0] rs2_data_in,
    input [4:0] rs1_in,
    input [4:0] rs2_in,
    input [4:0] rd_in,
    input [31:0] imm_in,

    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg MemToReg,
    output reg ALUSrc,

    output reg [31:0] pc,
    output reg [31:0] rs1_data,
    output reg [31:0] rs2_data,
    output reg [4:0] rs1,
    output reg [4:0] rs2,
    output reg [4:0] rd,
    output reg [31:0] imm
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        RegWrite <= 0; MemRead <= 0; MemWrite <= 0; MemToReg <= 0; ALUSrc <= 0;
        pc <= 0; rs1_data <= 0; rs2_data <= 0; rs1 <= 0; rs2 <= 0; rd <= 0; imm <= 0;
    end else begin
        RegWrite <= RegWrite_in;
        MemRead  <= MemRead_in;
        MemWrite <= MemWrite_in;
        MemToReg <= MemToReg_in;
        ALUSrc   <= ALUSrc_in;

        pc <= pc_in;
        rs1_data <= rs1_data_in;
        rs2_data <= rs2_data_in;
        rs1 <= rs1_in;
        rs2 <= rs2_in;
        rd <= rd_in;
        imm <= imm_in;
    end
end

endmodule
