module MUX_RegDst(
	input logic RegDst,
	input logic [31:0] rt,
	input logic [31:0] rd,
	output logic [31:0] RegDst_out
);

	assign RegDst_out= RegDst ? rd : rt;

endmodule
