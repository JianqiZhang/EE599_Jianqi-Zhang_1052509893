// File: ee599_assignment1_Q1.v
// Written by Jianqi Zhang, Mar 1, 2020
 
// This design includes all components of Odd-even transposition sort.
// It supports only n 8-bit arithmetic sort.
//-------------------------
`define NUMBER 16
`timescale 1 ns / 100 ps
module CompareUnit
(
input			rstb,
input			clk,
input	signed	[7:0]	A,
input	signed	[7:0]	B,
output  reg	signed  [7:0] 	Min,
output	reg	signed	[7:0]	Max
);
always @ (posedge clk, negedge rstb)
begin
	if (rstb == 1'b0)
		begin
			Min <= 0;
			Max <= 0;
		end
	else if (A > B)
			begin	
				Max <= A;
				Min <= B;
			end
		else
			begin
				Max <= B;
				Min <= A;
			end
end
endmodule // CompareUnit

module OddevenSort
#(
	parameter n = `NUMBER,
	parameter INPUT_WIDTH = n * 8,
	parameter Ini = 2'b00,
	parameter DataInput = 2'b01,
	parameter Sort = 2'b10,
	parameter DataOutput = 2'b11
)
(
	input			rstb,
	input			clk,
	input	[INPUT_WIDTH-1:0]	data_in,
	output	reg [INPUT_WIDTH-1:0]	data_out
);
wire [INPUT_WIDTH-1:0] Odd2Even;
//wire [INPUT_WIDTH-1:0] EvenOutNet
wire [INPUT_WIDTH-1:0] OddIn;
wire [INPUT_WIDTH-1:0] EvenOut;
reg OddInControl;
reg [7:0] LS_Buffer;
reg [7:0] MS_Buffer;
reg [7:0] cnt;
reg [1:0] state;
//reg data_enable;
//assign Even2Odd = Input_Buffer;
//assign Even2Odd = data_in;
//always @ (data_enable)
//begin
//    if (data_enable == 1)
//        Input_Buffer <= data_in;
//end
//always @ (cnt)
//begin
//    if (cnt == 0)
//        data_enable = 1'b1;
//end
//always @ (posedge clk, negedge rstb)
//begin
//    if (rstb == 1'b0)
//        Input_Buffer <= data_in;
//end
assign EvenOut[INPUT_WIDTH-1:INPUT_WIDTH-8] = MS_Buffer;
assign EvenOut[7:0] = LS_Buffer;
assign OddIn = OddInControl ? EvenOut : data_in; 
genvar i;
generate
	for (i = 0; i < n/2; i = i + 1) begin:  OddCompareUnit
		CompareUnit u(rstb, clk, OddIn[INPUT_WIDTH-i*16-1:INPUT_WIDTH-i*16-8], OddIn[INPUT_WIDTH-i*16-9:INPUT_WIDTH-i*16-16], Odd2Even[INPUT_WIDTH-i*16-1:INPUT_WIDTH-i*16-8], Odd2Even[INPUT_WIDTH-i*16-9:INPUT_WIDTH-i*16-16]);
	end
endgenerate
always @ (posedge clk, negedge rstb)
begin
		if (rstb == 1'b0)
		begin
			MS_Buffer <= 0;
			LS_Buffer <= 0;
		end
		else
			begin
				MS_Buffer <= Odd2Even[INPUT_WIDTH-1:INPUT_WIDTH-8]; 
				LS_Buffer <= Odd2Even[7:0];
				//EvenOut[INPUT_WIDTH-1:INPUT_WIDTH-8] <= MS_Buffer;
                //EvenOut[7:0] <= LS_Buffer;
			end
end
generate
	for (i = 0; i < (n/2)-1; i = i + 1) begin:  EvenCompareUnit
		CompareUnit u(rstb, clk, Odd2Even[INPUT_WIDTH-i*16-9:INPUT_WIDTH-i*16-16], Odd2Even[INPUT_WIDTH-i*16-17:INPUT_WIDTH-i*16-24], EvenOut[INPUT_WIDTH-i*16-9:INPUT_WIDTH-i*16-16], EvenOut[INPUT_WIDTH-i*16-17:INPUT_WIDTH-i*16-24]);
	end
endgenerate
always @ (posedge clk, negedge rstb)
begin
	if (rstb == 1'b0)
		begin
		  state <= 0;
	      cnt <= 0;
		end
	else
		begin
		  case (state)
		      Ini:
		          begin
		              OddInControl <= 0;
		              state <= DataInput;
		          end
		      DataInput:
		          begin
		              //OddIn <= data_in;
		              OddInControl <= 1;
		              cnt <= 0;
		              state <= Sort;
		          end
		      Sort:
		          begin
		              //OddIn <= EvenOut;
		              cnt <= cnt + 1;
		              data_out <= EvenOut;
		              if (cnt == n - 1)
		                  begin
		                      state <= DataOutput;
		                      //data_out <= EvenOut;
		                  end
		          end
		      DataOutput:
		          begin
		              //state <= Ini;
		          end
		endcase
		end
end
endmodule