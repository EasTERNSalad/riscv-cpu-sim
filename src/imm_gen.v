module imm_gen (
    input [31:0] instr,
    output reg [31:0] imm
);
    wire [6:0] opcode = instr[6:0];
    always @(*) begin
        case(opcode)
           7'b0010011, 7'b0000011 : imm = {{20{instr[31]}}, instr[31:20]}; // I_Type (Immediate), LW (LongWord), Sign-Extend (Sign is preserved) --> Stored in [31:20] then SignExtended to 32bits  
           7'b0100011 : imm = {{20{instr[31]}}, instr[31:25], instr[11:7]}; //S-type Immediate is split between [31:25] & [11:7] --> then SignExtended to 12bits Immediate 

           default: imm = 32'b0; //if opcode doesnt match known default to zero
        endcase
    end
endmodule