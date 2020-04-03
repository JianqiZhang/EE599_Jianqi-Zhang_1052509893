// File: ee599_assignment1_Q1_tb.v
// Written by Jianqi Zhang, Mar 1, 2020
 
// This design includes all components of Odd-even transposition sort.
// It supports only n 8-bit arithmetic sort.
//-------------------------
`define NUMBER 16
`define SELECTBITS 4
`timescale 1 ns / 100 ps
module BarrelShifter_tb
#(
	parameter k = `NUMBER,
	parameter SELECT_BITS = `SELECTBITS
);
reg clk_tb, rstb_tb;
wire [8*k-1:0] data_in_tb;
wire [SELECT_BITS-1:0] select_tb;
wire [8*k-1:0] data_out_tb;
reg [7:0] input_tb [k-1:0];
wire [7:0] output_tb [k-1:0];
//wire [8*k*SELECT_BITS-1:0] stage_inter_tb;
reg output_flag = 0;
integer cnt = 0;
localparam CLK_PERIOD = 10;

BarrelShifter DUT(.rstb(rstb_tb), .clk(clk_tb), .data_in(data_in_tb), .select(select_tb), .data_out(data_out_tb));

//assign stage_inter_tb = DUT.stage_inter;

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

assign select_tb = 4'd5;
always @ (posedge clk_tb, negedge rstb_tb)
	begin
        if (rstb_tb == 1'b0)
            begin
                input_tb[15] <= 8'hFF;
                input_tb[14] <= 8'hEE;
                input_tb[13] <= 8'hDD;
                input_tb[12] <= 8'hCC;
                input_tb[11] <= 8'hBB;
                input_tb[10] <= 8'hAA;
                input_tb[9] <= 8'h99;
                input_tb[8] <= 8'h88;
                input_tb[7] <= 8'h77;
                input_tb[6] <= 8'h66;
                input_tb[5] <= 8'h55;
                input_tb[4] <= 8'h44;
                input_tb[3] <= 8'h33;
                input_tb[2] <= 8'h22;
                input_tb[1] <= 8'h11;
                input_tb[0] <= 8'h00;
			end
		else 
		    cnt <= cnt + 1;
		if (cnt >= 3)
            output_flag = 1;
    end 
    
genvar i;
generate
    for (i = 0; i < k; i = i + 1)        begin:Interconn1
		assign data_in_tb[i*8+7:i*8] = input_tb[i];
    end     
endgenerate
generate
    for (i = 0; i < k; i = i + 1)        begin:Interconn2
		assign output_tb[i] = data_out_tb[i*8+7:i*8];
    end     
endgenerate

endmodule