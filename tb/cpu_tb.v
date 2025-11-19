`timescale 1ns/1ps
module cpu_tb;
    
    real cpi;

    localparam integer INSTR_COUNT = 8; 
    reg clk;
    reg reset;

    cpu_top UUT(
        .clk(clk),
        .reset(reset)
    );

    initial clk = 0;
    always #5 clk = ~clk;


    initial begin
        $dumpfile("wave/cpu_tb.vcd");
        $dumpvars(0, cpu_tb);
    end

    initial begin
        reset = 1;
        #20;
        reset = 0;

        #2000;

        $display("=== Simulation Summary ===");
        $display("Total Cycles = %0d", UUT.cycles);

        cpi = UUT.cycles / (INSTR_COUNT * 1.0);
        $display("CPI = %0f", cpi);

        $finish;        
    end
endmodule