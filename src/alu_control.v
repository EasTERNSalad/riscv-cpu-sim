module alu_control (
    input [1:0] ALUOp,         
    input [2:0] funct3,        // instr[14:12]
    input funct7_7,            // instr[30] (msb of funct7), used to detect SUB
    output reg [2:0] alu_ctrl  // to ALU
);

    always @(*) begin
        alu_ctrl = 3'b000;
        case (ALUOp)
            2'b00: alu_ctrl = 3'b000; 
            2'b01: begin 
                case (funct3)
                    3'b000: alu_ctrl = (funct7_7 ? 3'b001 : 3'b000); // SUB if funct7[5]=1 (for rv32)
                    3'b111: alu_ctrl = 3'b010; // AND
                    3'b110: alu_ctrl = 3'b011; // OR
                    default: alu_ctrl = 3'b000;
                endcase
            end
            default: alu_ctrl = 3'b000;
        endcase
    end
endmodule