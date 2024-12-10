module data_memory(
    input logic clk,          // Clock signal
    input logic rst,          // Reset signal (active low)
    input logic [31:0] A,     // Address input
    input logic [31:0] WD,    // Write data input
    input logic WE,           // Write enable signal
    output logic [31:0] RD,   // Read data output
    output logic [31:0] prode // Additional output for memory inspection
);

    // Declare a memory array of 256 32-bit words
    logic [31:0] memory [0:255];
    
    // Initialize memory with zeros
    initial begin
        for (int i = 0; i < 256; i++)
            memory[i] = 32'd0;
    end
    
    // Assign the value at the memory address specified by the 8 least significant bits of A to 'prode'
    assign prode = memory[A[7:0]];
    
    // Assign the value at the memory address specified by the 8 least significant bits of A to 'RD'
    assign RD = memory[A[7:0]];
     
    // Synchronous process that updates memory on the positive edge of the clock or reset
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            // Reset memory to zeros if reset is active
            for (int i = 0; i < 256; i++) begin
                memory[i] <= 32'd0;
            end
        end else if (WE) begin
            // Write data to memory if write enable (WE) is active
            memory[A[7:0]] <= WD;
        end
    end

endmodule
