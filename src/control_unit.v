module control_unit (
    input [6:0] opcode,
    output reg ALUSrc,
    output reg MemToReg,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg branch,
    output reg [1:0] ALUOp
);
always @(*) begin
    case (opcode)

        //R-typr
        7'b0110011: begin
            ALUSrc = 0;
            MemToReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            branch = 0;
            ALUOp = 2'b10; //R-type ALU
        end

        //I-type
        7'b0110011: begin
            ALUSrc = 1;
            MemToReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            branch = 0;
            ALUOp = 2'b11; //L-type ALU
        end

        //Load
        7'b0110011: begin
            ALUSrc = 1;
            MemToReg = 1;
            RegWrite = 1;
            MemRead = 1;
            MemWrite = 0;
            branch = 0;
            ALUOp = 2'b00; //Load 
        end

        //Store
        7'b0110011: begin
            ALUSrc = 0;
            MemToReg = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 1;
            branch = 0;
            ALUOp = 2'b00; //Store ALU
        end

        default: begin
            ALUSrc = 0;
            MemToReg = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 0;
            branch = 0;
            ALUOp = 2'b00; 
        end
    endcase
    end
endmodule