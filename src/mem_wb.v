module mem_wb (
    input clk, input reset,
    input RegWrite_in, input MemToReg_in,
    input [31:0] read_data_in, input [31:0] alu_result_in;
    input [4:0] rd_in,
    output reg [31:0] read_data, output reg [31:0] alu_result,
    output reg [4:0] rd
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            RegWrite <= 0; MemToReg <= 0; read_data <= 0; alu_result <=0, rd <=0;
        end else begin
            RegWrite <= RegWrite_in; MemToReg <= MemToReg_in; read_data <= read_data_in; alu_result <= alu_result_in; rd <= rd_in;
        end
    end
endmodule