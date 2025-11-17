module control (
    input [6:0] opcode,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg MemToReg,
    output reg ALUSrc,
    output reg [1:0] ALUOp // 00:Add | 01:R-Type
);
    always @(*) begin
        RegWrite = 0; MemRead = 0; MemWrite = 0; MemToReg = 0; ALUSrc = 0; ALUOp = 2'b00;
        case (opcode)
            7'b0110011: begin //Register Type [add c,a,b --> c = a + b]
                RegWrite = 1;
                ALUSrc = 0;
                ALUOp = 2'b01;
            end
            7'b0010011: begin //Immediate Type  [addi c,a,10 --> c = a + 10 ]
                RegWrite = 1;
                ALUSrc = 1;
                ALUOp = 2'b00;
            end 
            7'b0000011: begin //Long Word
                RegWrite = 1;
                MemRead = 1;
                MemToReg = 1;
                ALUSrc = 1;
                ALUOp = 2'b00;
            end
            7'b0100011: begin //Store Word
                MemWrite = 1;
                ALUSrc = 1;
                ALUOp = 2'b00;
            end

            default: begin
            end
            
        endcase
    end
endmodule
