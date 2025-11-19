module ex_mem(
    input clk,
    input reset,

    input RegWrite_in,
    input MemRead_in,
    input MemWrite_in,
    input MemToReg_in,

    input [31:0] alu_result_in,
    input [31:0] rs2_data_in,
    input [4:0]  rd_in,

    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg MemToReg,

    output reg [31:0] alu_result,
    output reg [31:0] rs2_data,
    output reg [4:0] rd
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        RegWrite <= 0; MemRead <= 0; MemWrite <= 0; MemToReg <= 0;
        alu_result <= 0; rs2_data <= 0; rd <= 0;
    end else begin
        RegWrite <= RegWrite_in;
        MemRead  <= MemRead_in;
        MemWrite <= MemWrite_in;
        MemToReg <= MemToReg_in;

        alu_result <= alu_result_in;
        rs2_data <= rs2_data_in;
        rd <= rd_in;
    end
end

endmodule
