// File: ee599_assignment2_Q1.v
// Written by Jianqi Zhang, Mar 22, 2020
 
// This design includes all components of barrel shifter.
// It supports only n 8-bit arithmetic sort.
//-------------------------
`define NUMBER 16
`define SELECTBITS 4
`timescale 1 ns / 100 ps
module Mux
(
input	wire	[7:0]	A,
input	wire	[7:0]	B,
input	wire	select,
output  wire	[7:0] 	out
);
assign out = (select == 1'b0) ? A : B;
endmodule // Mux

module StageRegister
#(
	parameter k = `NUMBER
)
(
	input			   rstb,
	input			   clk,
	input  [8*k-1:0]   in ,
	output	reg [8*k-1:0]	out
);
always @ (posedge clk, negedge rstb)
	begin
		if (rstb == 1'b0)
			out <= 0;
		else
			out <= in;
	end
endmodule //StageRegister

module ShiftStage
#(
	parameter k = `NUMBER,
	parameter shift = 1
)
(
	input				rstb,
	input				clk,
	input				select,
	input		[8*k-1:0]	data_in,
	output		[8*k-1:0]	data_out
);

wire 	[8*k-1:0]	mux_B_in;
wire	[8*k-1:0]	mux_out;
assign	mux_B_in[8*shift-1:0] = data_in[8*k-1:8*(k-shift)];
assign	mux_B_in[8*k-1:8*shift] = data_in[8*(k-shift)-1:0];
genvar j;
generate
	for (j = 0; j < k; j = j + 1) begin: MuxArray
		Mux m(data_in[8*j+7:8*j], mux_B_in[8*j+7:8*j], select, mux_out[8*j+7:8*j]);
		end
endgenerate
StageRegister SR(rstb, clk, mux_out, data_out);
endmodule  // ShiftStage

module BarrelShifter
#(
	parameter k = `NUMBER,
	parameter SELECT_BITS = `SELECTBITS
)
(
	input							rstb,
	input							clk,
	input		[8*k-1:0]			data_in,
	input		[SELECT_BITS-1:0]	select,
	output		[8*k-1:0]			data_out
);
wire [8*k*(SELECT_BITS+1)-1:0] stage_inter;
assign stage_inter[8*k-1:0] = data_in;
assign data_out = stage_inter[8*k*(SELECT_BITS+1)-1:8*k*SELECT_BITS];
genvar i;
generate
	for (i = 0; i < SELECT_BITS; i = i + 1) 
		begin:  StageArray
		ShiftStage #(`NUMBER, 1<<i) s(rstb, clk, select[i], stage_inter[8*k*(i+1)-1:8*k*i], stage_inter[8*k*(i+2)-1:8*k*(i+1)]);
		end
endgenerate
endmodule