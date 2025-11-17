`timescale 1ns/1ps

module alu_tb;

reg [31:0] a, b;
reg [2:0] alu_ctrl;
wire [31:0] result;
wire zero;

alu uut (
    .a(a),
    .b(b),
    .alu_ctrl(alu_ctrl),
    .result(result),
    .zero(zero)
);

initial begin
    $dumpfile("wave/alu.vcd");
    $dumpvars(0, alu_tb);

    a = 10; b = 20; alu_ctrl = 3'b000;
    #10

    a = 50; b = 20; alu_ctrl = 3'b001;
    #10;

    a = 32'hF0F0F0F0; b = 32'h0F0F0F0F; alu_ctrl = 3'b010;
    #10;

    a = 32'hF0F0F0F0; b = 32'h0F0F0F0F; alu_ctrl = 3'b011;
    #10;

    $finish;
end

endmodule
