module viterbisim;
   reg CLK, RST, valid_i, data_i;
   wire valid_e;
   wire [1:0] data_e;
   wire       valid_d, data_d;
   wire signed [63:0] data;
   integer    i, error;
   
   convolution convolution(CLK, RST, valid_i, data_i, valid_e, data_e);
   viterbi viterbi(CLK, RST, valid_e, data_e, valid_d, data_d);

   initial begin
      $dumpfile("viterbi.vcd");
      $dumpvars(0, viterbisim);
      CLK <= 1'b1;
      RST <= 1'b1;
      valid_i <= 1'b0;
      #10 RST <= 1'b0;
      #10 RST <= 1'b1;

      for (i = 0; i < 64; i = i + 1) begin
	 #10;
	 valid_i <= 1'b1;
	 data_i <= data[i];
      end

      #10 valid_i <= 1'b0;

      $write("send\t");
      for (i = 0; i < 64; i = i + 1) begin
	 $write("%b", data[i]);
      end
      $write("\n");
      
      $write("receive\t");
      i = 0;
      error = 0;
      while (i < 64) begin
	 #10;
	 if (valid_d == 1'b1) begin
	    $write("%b", data_d);
	    if (data_d != data[i]) error = error + 1;
	    i = i + 1;
	 end
      end
      $write("\n");

      $write("error\t%1d\n", error);

      #10 valid_i <= 1'b0;

      #10000 $finish;
   end

   always begin
      #5 CLK = ~CLK;
   end
      
   assign data[0] = 1'b0;
   assign data[1] = 1'b1;
   assign data[2] = 1'b0;
   assign data[3] = 1'b0;
   assign data[4] = 1'b1;
   assign data[5] = 1'b0;
   assign data[6] = 1'b0;
   assign data[7] = 1'b1;
   assign data[8] = 1'b0;
   assign data[9] = 1'b0;
   assign data[10] = 1'b1;
   assign data[11] = 1'b0;
   assign data[12] = 1'b0;
   assign data[13] = 1'b1;
   assign data[14] = 1'b0;
   assign data[15] = 1'b0;
   assign data[16] = 1'b1;
   assign data[17] = 1'b0;
   assign data[18] = 1'b0;
   assign data[19] = 1'b1;
   assign data[20] = 1'b0;
   assign data[21] = 1'b0;
   assign data[22] = 1'b1;
   assign data[23] = 1'b0;
   assign data[24] = 1'b0;
   assign data[25] = 1'b1;
   assign data[26] = 1'b0;
   assign data[27] = 1'b0;
   assign data[28] = 1'b1;
   assign data[29] = 1'b0;
   assign data[30] = 1'b0;
   assign data[31] = 1'b1;
   assign data[32] = 1'b0;
   assign data[33] = 1'b0;
   assign data[34] = 1'b1;
   assign data[35] = 1'b0;
   assign data[36] = 1'b0;
   assign data[37] = 1'b1;
   assign data[38] = 1'b0;
   assign data[39] = 1'b0;
   assign data[40] = 1'b1;
   assign data[41] = 1'b0;
   assign data[42] = 1'b0;
   assign data[43] = 1'b1;
   assign data[44] = 1'b0;
   assign data[45] = 1'b0;
   assign data[46] = 1'b1;
   assign data[47] = 1'b0;
   assign data[48] = 1'b0;
   assign data[49] = 1'b1;
   assign data[50] = 1'b0;
   assign data[50] = 1'b0;
   assign data[51] = 1'b1;
   assign data[52] = 1'b0;
   assign data[53] = 1'b0;
   assign data[54] = 1'b0;
   assign data[55] = 1'b1;
   assign data[56] = 1'b0;
   assign data[57] = 1'b0;
   assign data[58] = 1'b1;
   assign data[59] = 1'b0;
   assign data[60] = 1'b0;
   assign data[61] = 1'b1;
   assign data[62] = 1'b0;
   assign data[63] = 1'b0;
endmodule      
