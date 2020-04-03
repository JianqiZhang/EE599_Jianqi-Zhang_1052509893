// File: ee599_assignment2_Q2_tb.v
// Written by Jianqi Zhang, Mar 23, 2020
 
// This design is the testbench of Systolic Array for Dense Matrix-Matrix Multiplication.
// It supports only 8-bit nxn Matrix-Matrix Multiplication
//-------------------------
`define MATRIXSIZE 16
`define OUTPUTWIDTH 20// 8 bit + 8 bit + log2(MATRIXSIZE)
`timescale 1 ns / 100 ps
module SystolicArray_tb
#(
	parameter n = `MATRIXSIZE,
	parameter OW = `OUTPUTWIDTH
);
reg clk_tb, rstb_tb, output_flag;
reg		signed	[7:0] matrix_A[n-1:0][n-1:0];
reg		signed	[7:0] matrix_B[n-1:0][n-1:0];
wire	signed	[OW*n*n-1:0] matrix_out;
wire     signed [8*n-1:0] col_buffer;
wire     signed [8*n-1:0] row_buffer;
wire	signed	[OW-1:0] matrix_out_tb[n-1:0][n-1:0];
reg 	signed	[7:0] col_buffer_tb[n-1:0];
reg 	signed	[7:0] row_buffer_tb[n-1:0];
reg signed [7:0] i,j,k,cnt;
localparam CLK_PERIOD = 10;
wire [8*n*(n+1)-1:0] interconn;
integer A,B,S;
  
SystolicArray  DUT (.clk(clk_tb), .rstb(rstb_tb), .col_in(col_buffer), .row_in(row_buffer), .out(matrix_out));  // UUT instantiation
assign interconn = DUT.interconn;
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
 
initial
	begin : MATRIX_GENERATOR
	A = $fopen("../../../../Matrix_A.txt", "w");
	B = $fopen("../../../../Matrix_B.txt", "w");
	for (i = 0; i < n; i = i + 1)
		begin
		for (j = 0; j < n; j = j + 1)
			begin
				matrix_A[i][j] = $random % 128;
				matrix_B[i][j] = $random % 128;
				col_buffer_tb[i] = 0;
				row_buffer_tb[i] = 0;
				$fwrite(A, "%d ", matrix_A[i][j]);
				$fwrite(B, "%d ", matrix_B[i][j]);
			end
			$fwrite(A, "\n");$fwrite(B, "\n");
		end
	$fclose(A);
	$fclose(B);
	end
  
always @ (posedge clk_tb, negedge rstb_tb)
	begin
		if (rstb_tb == 1'b0)
		begin
		    cnt <= 0;
			k = 0;
			for (i = 0; i < n; i = i + 1)
			begin
				col_buffer_tb[i] <= 0;
				row_buffer_tb[i] <= 0;
			end
		end
		else
            begin
                cnt <= cnt + 1;
                if (cnt == 3 * n - 1)
                    begin
                    output_flag = 1;
                    S = $fopen("../../../../Matrix_Result.txt", "w");
                    for (i = 0; i < n; i = i + 1)
                        begin
                            for (j = 0; j < n; j = j + 1)
                                begin
                                    $fwrite(S, "%d ", matrix_out_tb[i][j]);
                                end
                            $fwrite(S, "\n");
		                  end
		              $fclose(S);
		              end   
		       if (cnt >= 3 * n - 2)
		          output_flag = 1;
		        else
                    output_flag = 0;
                for (i = 0; i < n; i = i + 1)
                    begin
                        k = cnt - i; 
                        if (k < 0 || k > n - 1 || cnt >= 2 * n - 1)
                            begin
                                col_buffer_tb[i] <= 0;
                                row_buffer_tb[i] <= 0;
                            end
                        else
                            begin
                                col_buffer_tb[i] <= matrix_A[i][k];
                                row_buffer_tb[i] <= matrix_B[k][i];				
                            end
                  end             
		end
	end
genvar p,q;
generate
    for (p = 0; p < n; p = p + 1) begin
        for (q = 0; q < n; q = q + 1) begin:IO_buffer
		assign matrix_out_tb[p][q] = matrix_out[OW*p*n+OW*q+OW-1:OW*p*n+OW*q];
		assign col_buffer[8*p+7:8*p] = col_buffer_tb[p];
		assign row_buffer[8*p+7:8*p] = row_buffer_tb[p];
    end     
    end
endgenerate
endmodule
