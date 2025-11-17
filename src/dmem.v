module dmem (
    input clk,
    input MemRead,
    input MemWrite,
    input [31:0] addr,
    input [31:0] wdata,
    output [31:0] rdata
);

    reg [31:0] mem[0:255];
    initial begin 
        mem[0] = 32'hDEADBEEF;
        mem[1] = 32'hCAFEBABE;
    end

assign rdata = (MemRead) ? mem[addr[9:2]] : 32'b0;

always @(posedge clk) begin
    if (MemWrite)
        mem[addr[9:2]] <= wdata;
end
endmodule