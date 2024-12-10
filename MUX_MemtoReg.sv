module MUX_MemtoReg(
    input logic MemtoReg,          // Control signal to select between ALUResult and RD
    input logic [31:0] ALUResult,  // ALU result input
    input logic [31:0] RD,         // Read data input from memory
    output logic [31:0] MemtoReg_out // Output based on MemtoReg selection
);

    // Assign MemtoReg_out based on the MemtoReg control signal
    // If MemtoReg is 1, output RD; if 0, output ALUResult
    assign MemtoReg_out = MemtoReg ? RD : ALUResult;

endmodule
