// File: ee599_assignment2_Q2.v
// Written by Jianqi Zhang, Mar 23, 2020
 
// This design includes all components of Systolic Array for Dense Matrix-Matrix Multiplication.
// It supports only 8-bit nxn Matrix-Matrix Multiplication
//-------------------------
`define MATRIXSIZE 16
`define OUTPUTWIDTH 20
`timescale 1 ns / 100 ps
module PE
#(
	parameter n = `MATRIXSIZE,
	parameter OW = `OUTPUTWIDTH
)
(
	input			rstb,
	input			clk,
	input	signed	[7:0]	in_A,
	input	signed	[7:0]	in_B,
	output  reg	signed  [7:0] out_A,
	output  reg	signed  [7:0] out_B,
	output  reg	signed  [OW-1:0] out_C
);
wire signed [OW-1:0] product;
wire signed [OW-1:0] sum;
assign product = {{(OW-8){in_A[7]}},in_A} * {{(OW-8){in_B[7]}},in_B};
//assign product = in_A * in_B;
assign sum = out_C + product;
always @ (posedge clk or negedge rstb)
begin
	if (rstb == 1'b0)
	   begin
		out_A <= 0;
		out_B <= 0;
		out_C <= 0;
		end
	else
	   begin
		out_A <= in_A;
		out_B <= in_B;
		out_C <= sum;
		end
end
endmodule // PE

module PERow
#(
	parameter n = `MATRIXSIZE,
	parameter OW = `OUTPUTWIDTH
)
(
	input			rstb,
	input			clk,
	input	signed	[8*n-1:0]	row_in,
	input	signed	[7:0]		col_A_in,
	output 	signed  [8*n-1:0] 	row_B_out,
	output 	signed  [OW*n-1:0] 	row_out
);
wire [8*(n+1)-1:0] interconn;
assign interconn[7:0] = col_A_in;

genvar i;
generate
	for (i = 0; i < n; i = i + 1) 
		begin:  PE_Row
		PE pe(rstb, clk, interconn[8*i+7:8*i], row_in[8*i+7:8*i], interconn[8*(i+1)+7:8*(i+1)], row_B_out[8*i+7:8*i], row_out[OW*(i+1)-1:OW*i]);
		end
endgenerate
endmodule //PERow

module SystolicArray
#(
	parameter n = `MATRIXSIZE,
	parameter OW = `OUTPUTWIDTH
)
(
	input			rstb,
	input			clk,
	input	signed	[8*n-1:0]	col_in,
	input	signed	[8*n-1:0]	row_in,
	output 	signed  [OW*n*n-1:0] 	out
);
wire [8*n*(n+1)-1:0] interconn;
assign interconn[8*n-1:0] = row_in;

genvar i;
generate
	for (i = 0; i < n; i = i + 1) 
		begin:  systolic_array
		PERow row(rstb, clk, interconn[8*n*(i+1)-1:8*n*i], col_in[8*i+7:8*i], interconn[8*n*(i+2)-1:8*n*(i+1)], out[OW*n*(i+1)-1:OW*n*i]);
		end
endgenerate
endmodule //SystolicArray
