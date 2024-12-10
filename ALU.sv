module ALU (
    input logic [31:0] SrcA,      // Operand A
    input logic [31:0] SrcB,      // Operand B
    input logic [2:0] ALUControl, // Control signal
    output logic [31:0] ALUResult // Result
);

    always_comb begin
        case (ALUControl)
            3'b010: ALUResult = SrcA + SrcB; // ADD
            3'b110: ALUResult = SrcA - SrcB; // SUB
            default: ALUResult = 32'b0;      // Default
        endcase
    end

endmodule
