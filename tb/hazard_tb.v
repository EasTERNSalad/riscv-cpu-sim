`timescale 1ns/1ps
module hazard_tb;
    reg [4:0] ifid_rs1, ifid_rs2, indec_rd;
    reg indec_memread;
    wire stall, ifid_write, pc_write;

    hazard_unit UUT(.ifid_rs1(ifid_rs1), .ifid_rs2(ifid_rs2), .indec_rd(indec_rd), .indec_memread(indec_memread), .stall(stall), .ifid_write(ifid_write), .pc_write(pc_write));

    initial begin
        $dumpfile("wave/hazard.vcd");
        $dumpvars(0, hazard_tb);
        
        //No Hazard
        ifid_rs1 = 5'd2; ifid_rs2 = 5'd3; indec_rd = 5'd5; indec_memread = 0; #10;
        $display("stall = %b | ifid_write = %b | pc_write = %b", stall, ifid_write, pc_write);

        //If INDEC_MEMREAD = 1 AND INDEC_RD = IFID_RS1
        ifid_rs1 = 5'd5; ifid_rs2 = 5'd3; indec_rd = 5'd5; indec_memread = 1; #10;
        $display("stall = %b | ifid_write = %b | pc_write = %b", stall, ifid_write, pc_write);

        //HAZARD WHEN IDEC_RD == IFID_RD2
        ifid_rs1 = 5'd1; ifid_rs2 = 5'd7; indec_rd = 5'd7; indec_memread = 1; #10;
        $display("stall = %b | ifid_write = %b | pc_write = %b", stall, ifid_write, pc_write);
    
        $finish;
    end
endmodule