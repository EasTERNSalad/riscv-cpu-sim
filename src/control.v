module control (
    input [6:0] opcode,
    output reg RegWrite,
    output reg ALUSrc
);
    always @(*) begin
        case (opcode)
            7'b0110011: begin
                RegWrite = 1;
                ALUSrc = 0;
            end
            7'b0010011: begin
                RegWrite = 1;
                ALUSrc = 1;
            end
            7'b0000011: begin
                RegWrite = 1;
                ALUSrc = 1;
            end
            7'b0100011: begin
                RegWrite = 0;
                ALUSrc = 1;
            end
            default: begin
                RegWrite = 0;
                ALUSrc = 0;
            end
        endcase
    end
endmodule
