module imem(
    input  [31:0] addr,
    output [31:0] instr
);

reg [31:0] mem [0:255];

assign instr = mem[addr >> 2];

integer i;

initial begin
    mem[0] = 32'h00500093; // addi x1, x0, 5
    mem[1] = 32'h00a00113; // addi x2, x0, 10
    mem[2] = 32'h002081b3; // add  x3, x1, x2
    mem[3] = 32'h00302023; // sw   x3, 0(x0)
    mem[4] = 32'h00002183; // lw   x4, 0(x0)
    mem[5] = 32'h00100293; // addi x5, x0, 1   
    mem[6] = 32'h00502023; // sw   x5, 4(x0)  (store x5 at byte offset 4)
    mem[7] = 32'h00402183; // lw   x6, 4(x0)
    mem[8] = 32'h00610333; // add  x7, x6, x2  
    mem[9] = 32'h00000013; // nop (addi x0,x0,0)

    for (i = 6; i < 256; i = i + 1) begin
        mem[i] = 32'h00000013; // addi x0,x0,0
    end
end

endmodule
