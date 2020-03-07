// File: ee599_assignment1_Q2_tb.v
// Written by Jianqi Zhang, Mar 1, 2020
 
// This design includes all components of Multiply and adder tree.
// It supports only 8-bit nxn Matrix-Matrix Multiplication
// the pipeline to support reverse assembly and forming the Time-Space diagram.
//-------------------------
`define ADDERWIDTH 16
`define MATRIXSIZE 4
`timescale 1 ns / 100 ps
module MulandAddTree_tb
#(
	parameter MATRIX_SIZE = `MATRIXSIZE,
	parameter INPUT_WIDTH = 8 * MATRIX_SIZE,
	parameter ADDER_WIDTH = `ADDERWIDTH,
	parameter OUTPUT_WIDTH = ADDER_WIDTH
);
reg clk_tb, rstb_tb;
reg	[INPUT_WIDTH-1:0]	Row;
reg	[INPUT_WIDTH-1:0]	Col;
//wire [7:0] Matrix_tb[MATRIXSIZE-1][MATRIXSIZE-1];
wire [OUTPUT_WIDTH-1:0] Output;
reg [5:0] cnt = 0;

localparam CLK_PERIOD = 20;
  
MulandAddTree  DUT (.clk(clk_tb), .rstb(rstb_tb), .Row(Row), .Col(Col), .Output(Output));  // UUT instantiation

initial
  begin  : CLK_GENERATOR
    clk_tb = 0;
    forever
       begin
	      #(CLK_PERIOD/2) clk_tb = ~clk_tb;
       end 
  end

initial
  begin  : RESET_GENERATOR
    rstb_tb = 0;
    #(10) rstb_tb = 1;
	
  end
  
  always @ (posedge clk_tb)
	begin
		cnt <= cnt + 1;
		if(cnt == (MATRIX_SIZE * MATRIX_SIZE-1))
			cnt <= 0;
/* 		case(cnt)
			6'd0000 : begin
						Row[31:0] = 32'h01020304;
						Col[31:0] = 32'h01000000;		
					end
			6'd0001 : begin
						Row[31:0] = 32'h01020304;
						Col[31:0] = 32'h00010000;		
					end
			6'd0002 : begin
						Row[31:0] = 32'h01020304;
						Col[31:0] = 32'h00000100;		
					end
			6'd0003 : begin
						Row[31:0] = 32'h01020304;
						Col[31:0] = 32'h00000001;	
					end
			6'd0004 : begin
						Row[31:0] = 32'h02030405;
						Col[31:0] = 32'h01000000;	
					end
			6'd0005 : begin
						Row[31:0] = 32'h02030405;
						Col[31:0] = 32'h00010000;	
					end		
			6'd0006 : begin
						Row[31:0] = 32'h02030405;
						Col[31:0] = 32'h00000100;	
					end
			6'd0007 : begin
						Row[31:0] = 32'h02030405;
						Col[31:0] = 32'h00000001;	
					end		
			6'd0008 : begin
						Row[31:0] = 32'h03040506;
						Col[31:0] = 32'h01000000;	
					end
			6'd0009 : begin
						Row[31:0] = 32'h03040506;
						Col[31:0] = 32'h00010000;	
					end		
			6'd0010 : begin
						Row[31:0] = 32'h03040506;
						Col[31:0] = 32'h00000100;	
					end
			6'd0011 : begin
						Row[31:0] = 32'h03040506;
						Col[31:0] = 32'h00000001;	
					end	
			6'd0012 : begin
						Row[31:0] = 32'h04050607;
						Col[31:0] = 32'h01000000;	
					end
			6'd0013 : begin
						Row[31:0] = 32'h04050607;
						Col[31:0] = 32'h00010000;	
					end			
			6'd0014 : begin
						Row[31:0] = 32'h04050607;
						Col[31:0] = 32'h00000100;	
					end
			6'd0015 : begin
						Row[31:0] = 32'h04050607;
						Col[31:0] = 32'h00000001;	
					end							
	endcase */
		case(cnt)
			6'd0000 : begin
						Row[31:0] = 32'h01020304;
						Col[31:0] = 32'h01020304;		
					end
			6'd0001 : begin
						Row[31:0] = 32'h01020304;
						Col[31:0] = 32'h02030405;		
					end
			6'd0002 : begin
						Row[31:0] = 32'h01020304;
						Col[31:0] = 32'h03040506;		
					end
			6'd0003 : begin
						Row[31:0] = 32'h01020304;
						Col[31:0] = 32'h04050607;	
					end
			6'd0004 : begin
						Row[31:0] = 32'h02030405;
						Col[31:0] = 32'h01020304;	
					end
			6'd0005 : begin
						Row[31:0] = 32'h02030405;
						Col[31:0] = 32'h02030405;	
					end		
			6'd0006 : begin
						Row[31:0] = 32'h02030405;
						Col[31:0] = 32'h03040506;	
					end
			6'd0007 : begin
						Row[31:0] = 32'h02030405;
						Col[31:0] = 32'h04050607;	
					end		
			6'd0008 : begin
						Row[31:0] = 32'h03040506;
						Col[31:0] = 32'h01020304;	
					end
			6'd0009 : begin
						Row[31:0] = 32'h03040506;
						Col[31:0] = 32'h02030405;	
					end		
			6'd0010 : begin
						Row[31:0] = 32'h03040506;
						Col[31:0] = 32'h03040506;	
					end
			6'd0011 : begin
						Row[31:0] = 32'h03040506;
						Col[31:0] = 32'h04050607;	
					end	
			6'd0012 : begin
						Row[31:0] = 32'h04050607;
						Col[31:0] = 32'h01020304;	
					end
			6'd0013 : begin
						Row[31:0] = 32'h04050607;
						Col[31:0] = 32'h02030405;	
					end			
			6'd0014 : begin
						Row[31:0] = 32'h04050607;
						Col[31:0] = 32'h03040506;	
					end
			6'd0015 : begin
						Row[31:0] = 32'h04050607;
						Col[31:0] = 32'h04050607;	
					end							
	endcase
end
endmodule

//  matrix1:
//  1   2   3   4
//  2   3   4   5
//  3   4   5   6
//  4   5   6   7

//  matrix2:
//  1   0   0   0
//  0   1   0   0 
//  0   0   1   0
//  0   0   0   1

//  matrix3:
//  1   2   3   4
//  2   3   4   5
//  3   4   5   6
//  4   5   6   7

//  matrix4:
//  1   2   3   4
//  2   3   4   5
//  3   4   5   6
//  4   5   6   7