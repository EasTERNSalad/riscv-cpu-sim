`timescale 1ns/1ps

module if_id_tb;

reg clk = 0;
reg reset = 1;

wire [31:0] pc;
wire [31:0] next_pc;
wire [31:0] instr;
wire [31:0] pc_id;
wire [31:0] instr_id;

assign next_pc = pc + 4;

// Instantiate modules
pc PC(
    .clk(clk),
    .reset(reset),
    .next_pc(next_pc),
    .pc(pc)
);

imem IMEM(
    .addr(pc),
    .instr(instr)
);

if_id IFID(
    .clk(clk),
    .reset(reset),
    .pc_in(pc),
    .instr_in(instr),
    .pc_out(pc_id),
    .instr_out(instr_id)
);

// Clock generation
always #5 clk = ~clk;

initial begin
    $dumpfile("wave/if_id.vcd");
    $dumpvars(0, if_id_tb);

    #10 reset = 0;
    #100;

    $finish;
end

endmodule
