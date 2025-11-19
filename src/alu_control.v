module alu_control (
    input [1:0] ALUOp,
    input [2:0] funct3,
    input [2:0] funct7_5,
    output reg [2:0] alu_cntrl,
);
always @(*) begin 
    case (ALUOp)

    2'b00: alu_cntrl = 3'b000; //LW->SW AAD
    2'b10: begin //RTYPE
        case(funct3)
            3'b000: alu_cntrl = (funct7_5 ? 3'b001 : 3'b000); //ADD or SUB
            3'b111: alu_cntrl = 3'b010; //AND
            3'b110: alu_cntrl = 3'b100; //OR
            default: alu_cntrl = 3'b000;
            end
    2'b11: alu_cntrl = 3'b000; //ITYPE
    default: alu_cntrl = 3'b000;
    endcase
end
endmodule
