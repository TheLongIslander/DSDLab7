module top(
    input logic clk,                   // Clock signal
    input logic rst,                   // Reset signal
    input logic [1:0] sw,              // Address selector for instruction memory
    output logic [31:0] ALUResult,     // ALU result output for pre-lab simulation
    output logic [31:0] RD1, RD2,      // Register data outputs for pre-lab simulation
    output logic [31:0] prode_register_file, // Register file inspection output for pre-lab
    output logic [31:0] prode_data_mem,      // Data memory inspection output for pre-lab
    output logic [6:0] display_led     // Output for 7-segment display (in-lab)
);

    // Define instructions for a simple instruction memory
    logic [31:0] inst_0 = 32'b0; // Default instruction (NOP)
    logic [31:0] inst_1 = 32'b100100_01000_00010_00001_0000_0000_000;  
    // Instruction 1: add rf_regs[5] and rf_regs[4] to rf_regs[1]
    logic [31:0] inst_2 = 32'b101100_01000_00011_00001_0000_0000_000;  
    // Instruction 2: sub rf_regs[10] - rf_regs[8] to rf_regs[1]

    logic [31:0] inst_ex; // Selected instruction based on `sw`
    assign inst_ex = (sw == 1) ? inst_1 : (sw == 2) ? inst_2 : inst_0; // Instruction selection logic

    // Define intermediate signals for control and data paths
    logic [31:0] SignImm, MemtoReg_out, ALUSrc_out, DataMem_out; // ALU source, sign-extended immediate, data memory output, and MUX outputs
    logic [4:0] RegDst_out; // Register destination output

    // Register File Instance
    register_file r_f(
        .clk(clk),
        .rst(rst),
        .A1(inst_ex[25:21]),        // First register address from instruction
        .A2(inst_ex[20:16]),        // Second register address from instruction
        .A3(inst_ex[15:11]),        // Write register address from instruction
        .WD3(ALUResult),            // Data to write into register
        .WE3(1),                    // Write enable always active (for simplicity)
        .RD1(RD1),                  // First read data output
        .RD2(RD2),                  // Second read data output
        .prode(prode_register_file) // Register file inspection output
    );

    // ALU Instance
    ALU t1(
        .SrcA(RD1),                  // First operand for ALU
        .SrcB(RD2),                  // Second operand for ALU
        .ALUControl(inst_ex[29:27]), // ALU control signals from instruction
        .ALUResult(ALUResult)        // Result from ALU
    );

    // Data Memory Instance
    data_memory d_mem(
        .clk(clk),
        .rst(rst),
        .A(ALUResult),               // Address from ALU result
        .WD(RD2),                    // Data to write to memory
        .WE(inst_ex[31:26] == 6'b010100), // Write enable when specific opcode is active
        .RD(DataMem_out),            // Data read from memory
        .prode(prode_data_mem)       // Data memory inspection output
    );

    // Sign Extension Instance
    sign_extend s_extend(
        .Imm(inst_ex[15:0]),         // Immediate value from instruction
        .SignImm(SignImm)            // Sign-extended immediate output
    );

    // Register Destination MUX Instance
    MUX_RegDst mux_regdst(
        .RegDst(inst_ex[31:26] == 6'b010101), // Control signal for selecting register destination
        .rt(inst_ex[20:16]),                  // `rt` register address
        .rd(inst_ex[15:11]),                  // `rd` register address
        .RegDst_out(RegDst_out)               // MUX output for register destination
    );

    // ALU Source MUX Instance
    MUX_ALUSrc mux_alusrc(
        .ALUSrc(1'b1),                // Control signal for ALU source (fixed to immediate for simplicity)
        .RD2(RD2),                    // Register data from RD2
        .SignImm(SignImm),            // Sign-extended immediate
        .ALUSrc_out(ALUSrc_out)       // MUX output for ALU source
    );

    // Memory to Register MUX Instance
    MUX_MemtoReg mux_memtoreg(
        .MemtoReg(inst_ex[31:26] == 6'b010101), // Control signal for memory-to-register path
        .ALUResult(ALUResult),                  // ALU result input
        .RD(DataMem_out),                       // Data memory output
        .MemtoReg_out(MemtoReg_out)             // MUX output for memory to register
    );

    // 7-Segment Display Instance
    display t2(
        .data_in(prode_register_file), // Data input for display (from register file inspection)
        .segments(display_led)         // Output for 7-segment display
    );

endmodule
