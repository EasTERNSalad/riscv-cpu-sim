`timescale 1ns/1ps
module dmem_tb;
    reg clk;
    reg MemRead, MemWrite;
    reg [31:0] addr, wdata;
    wire [31:0] rdata;

    dmem UUT(.clk(clk), .MemRead(MemRead), .MemWrite(MemWrite), .addr(addr), .wdata(wdata), .rdata(rdata));
    initial begin
        $dumpfile("wave/dmem.vcd");
        $dumpvars(0, dmem_tb);
        clk = 0; MemRead = 0; MemWrite = 0; addr = 0; wdata = 0;
        #10;

        MemRead = 1; addr = 0; #10;
        $display("ReadMem[0] = %h", rdata);

        MemRead = 0; MemWrite = 1; addr = 8; wdata = 32'h12345678; #10;
        MemWrite = 0; MemRead = 1; addr = 8; #10;
        $display("ReadMem[2] = %h", rdata);

        $finish;
    end

    always #5 clk = ~clk;

endmodule