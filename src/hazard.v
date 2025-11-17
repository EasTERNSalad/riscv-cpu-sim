module hazard_unit (
    input [4:0] ifid_rs1, ifid_rs2,
    input [4:0] indec_rd,
    input indec_memread,
    output reg stall,
    output reg ifid_write,
    output reg pc_write
);
    always @(*) begin
        if (indec_memread && ((indec_rd == ifid_rs1) || (indec_rd == ifid_rs2))) begin
            stall = 1;
            ifid_write = 0;
            pc_write = 0;
        end
    end
endmodule