`timescale 1ns/1ps

module cpu_tb();

reg clk;
reg reset;

cpu_top UUT(
    .clk(clk),
    .reset(reset)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    $dumpfile("wave/cpu_tb.vcd");
    $dumpvars(0, cpu_tb);
end

integer i;
localparam MAX_CYCLES = 200;
localparam [31:0] LAST_PROG_ADDR = 32'h14;

initial begin
    reset = 1;
    #20 reset = 0;

    for (i = 0; i < MAX_CYCLES; i = i + 1) begin : test_loop
        #10;

        $display("=== Cycle %0d ===", i);

        $display("PC            = %h", UUT.pc);
        $display("IF instr      = %h", UUT.instr);
        $display("IF/ID instr   = %h", UUT.instr_ifid);

        $display("ID rs1=%0d rs2=%0d rd=%0d", UUT.rs1, UUT.rs2, UUT.rd);
        $display("ID rs1_data   = %h", UUT.rs1_data);
        $display("ID rs2_data   = %h", UUT.rs2_data);
        $display("ID imm        = %h", UUT.imm);

        $display("ID/EX imm     = %h", UUT.imm_indec);

        $display("ALU result    = %h", UUT.alu_res);
        $display("EX/MEM ALU    = %h", UUT.alu_exmem);
        $display("MEM read_data = %h", UUT.mem_read_data);

        $display("WB writeback  = %h", UUT.wb_data);
        $display("WB: RegWrite=%b rd=%0d wb_data=%h",
                  UUT.RegWrite_memwb, UUT.rd_memwb, UUT.wb_data);

        // end condition
        if ((UUT.pc > LAST_PROG_ADDR) &&
            (UUT.RegWrite_indec == 0) &&
            (UUT.RegWrite_exmem == 0) &&
            (UUT.RegWrite_memwb == 0)) begin
            $display("Program done at cycle %0d", i);
            disable test_loop;
        end
    end

    $finish;
end

endmodule
