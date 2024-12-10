module register_file (
    input logic clk,
    input logic rst,         // Reset signal
    input logic [4:0] A1, A2, A3, // Register addresses
    input logic [31:0] WD3,
    input logic WE3,
    output logic [31:0] RD1,
    output logic [31:0] RD2,
    output logic [31:0] prode  // Value check for register 1
);

    // 32 registers, each 32 bits
    logic [31:0] rf_regs [0:31];

    // Initialize on active-low reset
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            for (int i = 0; i < 32; i++) begin
                rf_regs[i] <= i;
            end
        end else if (WE3) begin
            rf_regs[A3] <= WD3;  // Write if enabled
        end
    end

    // Read register values
    assign RD1 = rf_regs[A1];
    assign RD2 = rf_regs[A2];
    assign prode = rf_regs[1];
    
endmodule
