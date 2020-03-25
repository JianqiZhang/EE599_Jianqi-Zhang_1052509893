// File: ee599_assignment1_Q1_tb.v
// Written by Jianqi Zhang, Mar 1, 2020
 
// This design includes all components of Odd-even transposition sort.
// It supports only n 8-bit arithmetic sort.
//-------------------------
`define NUMBER 16
`timescale 1 ns / 100 ps
module OddevenSort_tb
#(
	parameter n = `NUMBER,
	parameter INPUT_NUM = n
);
reg clk_tb, rstb_tb;
wire [8*INPUT_NUM-1:0] data_in_tb;
reg [7:0] input_tb [INPUT_NUM-1:0];
wire [7:0] output_tb [INPUT_NUM-1:0];
wire [8*INPUT_NUM-1:0] data_out_tb;
wire [8*INPUT_NUM-1:0] EvenOut_tb;
wire [7:0] cnt_tb;
wire [1:0] state_tb;
reg [7:0] tempi;
localparam CLK_PERIOD = 10;

OddevenSort DUT(.rstb(rstb_tb), .clk(clk_tb), .data_in(data_in_tb), .data_out(data_out_tb));

assign EvenOut_tb = DUT.EvenOut;
assign cnt_tb = DUT.cnt;
assign state_tb = DUT.state;
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
  
  always @ (posedge clk_tb, negedge rstb_tb)
	begin
        if (rstb_tb == 1'b0)
            begin
                input_tb[15] <= 8'hAB;
                input_tb[14] <= 8'h15;
                input_tb[13] <= 8'h43;
                input_tb[12] <= 8'h54;
                input_tb[11] <= 8'h05;
                input_tb[10] <= 8'h18;
                input_tb[9] <= 8'hEF;
                input_tb[8] <= 8'h00;
                input_tb[7] <= 8'hFA;
                input_tb[6] <= 8'hBC;
                input_tb[5] <= 8'h63;
                input_tb[4] <= 8'h58;
                input_tb[3] <= 8'h12;
                input_tb[2] <= 8'h33;
                input_tb[1] <= 8'h99;
                input_tb[0] <= 8'h15;
           end
    end 
    
genvar i;
generate
    for (i = 0; i < INPUT_NUM; i = i + 1)        begin:Interconn1
		assign data_in_tb[i*8+7:i*8] = input_tb[i];
    end     
endgenerate
generate
    for (i = 0; i < INPUT_NUM; i = i + 1)        begin:Interconn2
		assign output_tb[i] = data_out_tb[i*8+7:i*8];
    end     
endgenerate

endmodule