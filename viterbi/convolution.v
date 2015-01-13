module convolution(CLK, RST, valid_i, data_i, valid_o, data_o);
   input 	    CLK, RST, valid_i, data_i;
   output reg 	    valid_o;
   output reg [1:0] data_o;

   reg 		    d1, d2;
   reg [5:0] 	    count;
   
   always @(posedge CLK or negedge RST) begin
      if (RST == 1'b0) begin
	 count <= 6'd0;
	 d1 <= 1'b0;
	 d2 <= 1'b0;
	 valid_o <= 1'b0;
      end else begin
	 valid_o <= valid_i;
	 data_o[0] <= data_i ^ d2;
	 data_o[1] <= data_i ^ d1 ^ d2;
	 if (count != 6'd63 && valid_i == 1'b1) begin
	    count <= count + 6'd1;
	    d1 <= data_i;
	    d2 <= d1;
	 end else if (count == 6'd63 && valid_i == 1'b1) begin
	    count <= 6'd0;
	    d1 <= 1'b0;
	    d2 <= 1'b0;
	 end
      end
   end
endmodule
