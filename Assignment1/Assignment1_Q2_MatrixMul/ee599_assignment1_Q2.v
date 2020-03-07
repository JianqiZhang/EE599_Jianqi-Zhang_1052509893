// File: ee599_assignment1_Q2.v
// Written by Jianqi Zhang, Mar 1, 2020
 
// This design includes all components of Multiply and adder tree.
// It supports only 8-bit nxn Matrix-Matrix Multiplication
// the pipeline to support reverse assembly and forming the Time-Space diagram.
//-------------------------
`define ADDERWIDTH 16
`define MATRIXSIZE 4
`timescale 1 ns / 100 ps
module MultiplyUnit 
(
input			rstb,
input			clk,
input	signed	[7:0]	A,
input	signed	[7:0]	B,
output  reg	signed  [15:0] Product
);
always @ (posedge clk, negedge rstb)
begin
	if (rstb == 1'b0)
		Product <= 0;
	else
		Product <= A * B;
end
endmodule // MultiplyUnit

//-------------------------
`timescale 1 ns / 100 ps
module Adder
#(
	parameter ADDER_WIDTH = `ADDERWIDTH
)
(
input			rstb,
input			clk,
input	signed	[ADDER_WIDTH-1:0]	A,
input	signed	[ADDER_WIDTH-1:0]	B,
output  reg	signed	[ADDER_WIDTH-1:0] Sum
);
always @ (posedge clk, negedge rstb)
begin
	if (rstb == 1'b0)
		Sum <= 0;
	else
		Sum <= A + B;
end
endmodule // Adder

//-------------------------
`timescale 1 ns / 100 ps
module MultiplyStage
#(
	parameter MATRIX_SIZE = `MATRIXSIZE,
	parameter INPUT_WIDTH = 8 * MATRIX_SIZE,
	parameter OUTPUT_WIDTH = 16 * MATRIX_SIZE
)
(
input			rstb,
input			clk,
input	[INPUT_WIDTH-1:0]	Row,
input	[INPUT_WIDTH-1:0]	Col,
output  [OUTPUT_WIDTH-1:0] Row_X_Col
);
genvar i;
generate
	for(i = 0; i < MATRIX_SIZE; i = i + 1) begin: MUL
		MultiplyUnit u(rstb, clk, Row[i*8+7:i*8], Col[i*8+7:i*8], Row_X_Col[i*16+15:i*16]);
	end
endgenerate
endmodule // MultiplyStage

//-------------------------
`timescale 1 ns / 100 ps
module AdderStage
#(
	parameter MATRIX_SIZE = `MATRIXSIZE,
	parameter ADDER_WIDTH = `ADDERWIDTH,
	parameter INPUT_WIDTH = ADDER_WIDTH * MATRIX_SIZE,
	parameter OUTPUT_WIDTH = ADDER_WIDTH,
	parameter TEMP_WIRE_NUMBER = 2 * MATRIX_SIZE - 1,
	parameter TEMP_WIRE_WIDTH = ADDER_WIDTH * TEMP_WIRE_NUMBER
)
(
input			rstb,
input			clk,
input	[INPUT_WIDTH-1:0]	adderstageinput,
output  [OUTPUT_WIDTH-1:0] result
);
wire [TEMP_WIRE_WIDTH-1:0]	temp_interconnect;
assign temp_interconnect[TEMP_WIRE_WIDTH-1:TEMP_WIRE_WIDTH-MATRIX_SIZE*ADDER_WIDTH] = adderstageinput;
assign result = temp_interconnect[TEMP_WIRE_WIDTH-1:0];
genvar i;
generate
	for(i = 1; i <= MATRIX_SIZE - 1; i = i + 1) begin: ADD
			Adder u(rstb, clk, temp_interconnect[2*i*ADDER_WIDTH-1:(2*i-1)*ADDER_WIDTH], temp_interconnect[(2*i+1)*ADDER_WIDTH-1:(2*i)*ADDER_WIDTH], temp_interconnect[i*ADDER_WIDTH-1:(i-1)*ADDER_WIDTH]);
	end
endgenerate
endmodule // AdderStage

//-------------------------
`timescale 1 ns / 100 ps
module MulandAddTree
#(
	parameter MATRIX_SIZE = `MATRIXSIZE,
	parameter INPUT_WIDTH = 8 * MATRIX_SIZE,
	parameter ADDER_WIDTH = `ADDERWIDTH,
	parameter TEMP_WIDTH = 16 * MATRIX_SIZE,
	parameter OUTPUT_WIDTH = ADDER_WIDTH
)
(
input			rstb,
input			clk,
input	[INPUT_WIDTH-1:0]	Row,
input	[INPUT_WIDTH-1:0]	Col,
output  [OUTPUT_WIDTH-1:0] Output
);
wire [TEMP_WIDTH-1:0] Row_X_Col;
genvar i;
generate
	MultiplyStage u0(rstb, clk, Row, Col, Row_X_Col);
	AdderStage u1(rstb, clk, Row_X_Col, Output);
endgenerate
endmodule // MulandAddTree


