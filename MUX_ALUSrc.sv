module MUX_ALUSrc(
    input logic ALUSrc,            // Control signal to select between RD2 and SignImm
    input logic [31:0] RD2,        // Register data input
    input logic [31:0] SignImm,    // Sign-extended immediate input
    output logic [31:0] ALUSrc_out // Output based on ALUSrc selection
);

    // Assign ALUSrc_out based on the ALUSrc control signal
    // If ALUSrc is 1, output SignImm; if 0, output RD2
    assign ALUSrc_out = ALUSrc ? SignImm : RD2;

endmodule
