module dmem (
    input clk,
    input MemRead,
    input MemWrite,
    input [31:0] addr,
    input [31:0] wdata,
    output reg [31:0] rdata
);

    reg [31:0] mem[0:255];

    initial begin
        mem[0] = 32'hDEADBEEF;
        mem[1] = 32'hCAFEBABE;
    end

    wire [7:0] waddr = addr[9:2];

    always @(*) begin
        if (MemRead)
            rdata = mem[waddr];
        else
            rdata = 32'b0;
    end

    always @(posedge clk) begin
        if (MemWrite)
            mem[waddr] <= wdata;
    end

endmodule
