module fft64sim;
   reg              CLK, RST, valid_a;
   reg signed [10:0] ar, ai;
   wire 	     valid_o;
   wire signed [10:0] xr, xi;
   wire 		   valid_d;
   wire signed [10:0] dr, di;
   wire signed [10:0] testar[0:63], testai[0:63], testxr[0:63], testxi[0:63];
   integer 	      i;
   wire 	      _valid_a;
   wire signed [10:0] _ar, _ai;
   
   assign testar[0] = 5;
   assign testai[0] = 15;
   assign testxr[0] = -83;
   assign testxi[0] = 440;
   assign testar[1] = 1;
   assign testai[1] = 3;
   assign testxr[1] = -7;
   assign testxi[1] = -6;
   assign testar[2] = -12;
   assign testai[2] = 3;
   assign testxr[2] = 64;
   assign testxi[2] = 59;
   assign testar[3] = -7;
   assign testai[3] = 11;
   assign testxr[3] = 28;
   assign testxi[3] = -7;
   assign testar[4] = 1;
   assign testai[4] = 11;
   assign testxr[4] = -15;
   assign testxi[4] = 10;
   assign testar[5] = 12;
   assign testai[5] = 7;
   assign testxr[5] = 19;
   assign testxi[5] = 70;
   assign testar[6] = -13;
   assign testai[6] = 5;
   assign testxr[6] = 43;
   assign testxi[6] = 92;
   assign testar[7] = -8;
   assign testai[7] = 14;
   assign testxr[7] = -62;
   assign testxi[7] = -31;
   assign testar[8] = 13;
   assign testai[8] = 4;
   assign testxr[8] = -50;
   assign testxi[8] = 47;
   assign testar[9] = -8;
   assign testai[9] = 1;
   assign testxr[9] = 7;
   assign testxi[9] = -13;
   assign testar[10] = 4;
   assign testai[10] = 5;
   assign testxr[10] = -55;
   assign testxi[10] = 33;
   assign testar[11] = 1;
   assign testai[11] = 11;
   assign testxr[11] = -42;
   assign testxi[11] = 9;
   assign testar[12] = -6;
   assign testai[12] = 2;
   assign testxr[12] = 38;
   assign testxi[12] = 116;
   assign testar[13] = -10;
   assign testai[13] = 10;
   assign testxr[13] = -44;
   assign testxi[13] = -67;
   assign testar[14] = 0;
   assign testai[14] = 6;
   assign testxr[14] = -25;
   assign testxi[14] = -10;
   assign testar[15] = -4;
   assign testai[15] = 4;
   assign testxr[15] = 79;
   assign testxi[15] = -85;
   assign testar[16] = -9;
   assign testai[16] = 7;
   assign testxr[16] = 18;
   assign testxi[16] = 47;
   assign testar[17] = -9;
   assign testai[17] = 3;
   assign testxr[17] = -77;
   assign testxi[17] = -45;
   assign testar[18] = -8;
   assign testai[18] = 12;
   assign testxr[18] = 70;
   assign testxi[18] = -54;
   assign testar[19] = -7;
   assign testai[19] = 11;
   assign testxr[19] = 38;
   assign testxi[19] = -58;
   assign testar[20] = 14;
   assign testai[20] = 0;
   assign testxr[20] = -44;
   assign testxi[20] = -7;
   assign testar[21] = 11;
   assign testai[21] = 2;
   assign testxr[21] = 31;
   assign testxi[21] = 46;
   assign testar[22] = 8;
   assign testai[22] = 2;
   assign testxr[22] = -74;
   assign testxi[22] = -17;
   assign testar[23] = -7;
   assign testai[23] = 12;
   assign testxr[23] = 71;
   assign testxi[23] = 20;
   assign testar[24] = -4;
   assign testai[24] = 0;
   assign testxr[24] = 13;
   assign testxi[24] = -5;
   assign testar[25] = 3;
   assign testai[25] = 11;
   assign testxr[25] = 53;
   assign testxi[25] = 56;
   assign testar[26] = -7;
   assign testai[26] = 4;
   assign testxr[26] = 49;
   assign testxi[26] = -52;
   assign testar[27] = 0;
   assign testai[27] = 4;
   assign testxr[27] = -40;
   assign testxi[27] = -64;
   assign testar[28] = -5;
   assign testai[28] = 15;
   assign testxr[28] = 12;
   assign testxi[28] = 15;
   assign testar[29] = -2;
   assign testai[29] = 7;
   assign testxr[29] = -2;
   assign testxi[29] = -10;
   assign testar[30] = 10;
   assign testai[30] = 2;
   assign testxr[30] = -53;
   assign testxi[30] = -61;
   assign testar[31] = 14;
   assign testai[31] = 7;
   assign testxr[31] = 124;
   assign testxi[31] = -25;
   assign testar[32] = -8;
   assign testai[32] = 7;
   assign testxr[32] = 99;
   assign testxi[32] = -16;
   assign testar[33] = -3;
   assign testai[33] = 10;
   assign testxr[33] = 49;
   assign testxi[33] = 37;
   assign testar[34] = -15;
   assign testai[34] = 0;
   assign testxr[34] = 4;
   assign testxi[34] = 49;
   assign testar[35] = -5;
   assign testai[35] = 9;
   assign testxr[35] = -20;
   assign testxi[35] = 119;
   assign testar[36] = 8;
   assign testai[36] = 4;
   assign testxr[36] = -66;
   assign testxi[36] = 33;
   assign testar[37] = -12;
   assign testai[37] = 9;
   assign testxr[37] = 75;
   assign testxi[37] = 89;
   assign testar[38] = -12;
   assign testai[38] = 13;
   assign testxr[38] = -52;
   assign testxi[38] = 81;
   assign testar[39] = 5;
   assign testai[39] = 13;
   assign testxr[39] = -5;
   assign testxi[39] = 0;
   assign testar[40] = 4;
   assign testai[40] = 13;
   assign testxr[40] = 20;
   assign testxi[40] = -17;
   assign testar[41] = -8;
   assign testai[41] = 2;
   assign testxr[41] = 86;
   assign testxi[41] = 6;
   assign testar[42] = 2;
   assign testai[42] = 15;
   assign testxr[42] = -62;
   assign testxi[42] = -23;
   assign testar[43] = 8;
   assign testai[43] = 4;
   assign testxr[43] = -24;
   assign testxi[43] = -58;
   assign testar[44] = -8;
   assign testai[44] = 15;
   assign testxr[44] = -61;
   assign testxi[44] = 121;
   assign testar[45] = -9;
   assign testai[45] = 1;
   assign testxr[45] = -41;
   assign testxi[45] = 68;
   assign testar[46] = -14;
   assign testai[46] = 5;
   assign testxr[46] = 10;
   assign testxi[46] = 102;
   assign testar[47] = 2;
   assign testai[47] = 14;
   assign testxr[47] = 0;
   assign testxi[47] = 3;
   assign testar[48] = 12;
   assign testai[48] = 11;
   assign testxr[48] = 162;
   assign testxi[48] = -7;
   assign testar[49] = -13;
   assign testai[49] = 4;
   assign testxr[49] = 92;
   assign testxi[49] = 109;
   assign testar[50] = 3;
   assign testai[50] = 2;
   assign testxr[50] = -65;
   assign testxi[50] = 39;
   assign testar[51] = 6;
   assign testai[51] = 11;
   assign testxr[51] = 54;
   assign testxi[51] = 35;
   assign testar[52] = 10;
   assign testai[52] = 8;
   assign testxr[52] = -12;
   assign testxi[52] = -112;
   assign testar[53] = -9;
   assign testai[53] = 1;
   assign testxr[53] = -41;
   assign testxi[53] = 6;
   assign testar[54] = -6;
   assign testai[54] = 9;
   assign testxr[54] = 2;
   assign testxi[54] = -14;
   assign testar[55] = -7;
   assign testai[55] = 15;
   assign testxr[55] = 79;
   assign testxi[55] = -30;
   assign testar[56] = 10;
   assign testai[56] = 2;
   assign testxr[56] = 5;
   assign testxi[56] = -17;
   assign testar[57] = -6;
   assign testai[57] = 4;
   assign testxr[57] = -63;
   assign testxi[57] = 77;
   assign testar[58] = 6;
   assign testai[58] = 1;
   assign testxr[58] = 68;
   assign testxi[58] = -108;
   assign testar[59] = -12;
   assign testai[59] = 4;
   assign testxr[59] = -50;
   assign testxi[59] = -13;
   assign testar[60] = 12;
   assign testai[60] = 2;
   assign testxr[60] = -37;
   assign testxi[60] = -7;
   assign testar[61] = 3;
   assign testai[61] = 3;
   assign testxr[61] = 5;
   assign testxi[61] = 43;
   assign testar[62] = 13;
   assign testai[62] = 12;
   assign testxr[62] = -18;
   assign testxi[62] = -53;
   assign testar[63] = -11;
   assign testai[63] = 6;
   assign testxr[63] = 41;
   assign testxi[63] = -23;
   
   fft64 fft64(CLK, RST, _valid_a, _ar, _ai, valid_o, xr, xi);
   ifft64 ifft64(CLK, RST, valid_o, xr, xi, valid_d, dr, di);
   input_register input_register(CLK, valid_a, ar, ai, _valid_a, _ar, _ai);

   initial begin
      $dumpfile("fft64.vcd");
      $dumpvars(0, fft64sim);
      CLK <= 1'b1;
      RST <= 1'b1;
      valid_a <= 1'b0;
      #10 RST <= 1'b0;
      #10 RST <= 1'b1;

      for (i = 0; i < 64; i = i + 1) begin
	 #10;
         valid_a <= 1'b1;
         ar <= testar[i];
         ai <= testai[i];
      end

      #10 valid_a <= 1'b0;

      $write("FFT Done\n");

      i = 0;
      while (i < 64) begin
         #10;
         if (valid_o == 1'b1) begin
            $write("xr[%2d] output=%4d expected=%4d xi[%2d] output=%4d expected=%4d", i, xr, testxr[i], i, xi, testxi[i]);
	    if ((xr == testxr[i] - 11'd3 || xr == testxr[i] - 11'd2 || xr == testxr[i] - 11'd1 || xr == testxr[i] || xr == testxr[i] + 11'd1 || xr == testxr[i] + 11'd2 || xr == testxr[i] + 11'd3) && (xi == testxi[i] - 11'd3 || xi == testxi[i] - 11'd2 || xi == testxi[i] - 11'd1 || xi == testxi[i] || xi == testxi[i] + 11'd1 || xi == testxi[i] + 11'd2 || xi == testxi[i] + 11'd3)) begin
	       $write(" OK\n");
	    end else begin
	       $write(" ERROR\n");
	    end
            i = i + 1;
         end
      end

      $write("IFFT Done\n");

      i = 0;
      while (i < 64) begin
         #10;
         if (valid_d == 1'b1) begin
            $write("dr[%2d] output=%4d expected=%4d di[%2d] output=%4d expected=%4d", i, dr, testar[i], i, di, testai[i]);
	    if ((dr == testar[i] - 11'd3 || dr == testar[i] - 11'd2 || dr == testar[i] - 11'd1 || dr == testar[i] || dr == testar[i] + 11'd1 || dr == testar[i] + 11'd2 || dr == testar[i] + 11'd3) && (di == testai[i] - 11'd3 || di == testai[i] - 11'd2 || di == testai[i] - 11'd1 || di == testai[i] || di == testai[i] + 11'd1 || di == testai[i] + 11'd2 || di == testai[i] + 11'd3)) begin
	       $write(" OK\n");
	    end else begin
	       $write(" INCORRECT\n");
	    end
            i = i + 1;
         end
      end

      #1000 $finish;
   end

   always begin
      #5 CLK <= ~CLK;
   end
endmodule

module input_register(CLK, valid_a, ar, ai, _valid_a, _ar, _ai);
   input CLK, valid_a;
   input signed [10:0] ar, ai;
   output reg	       _valid_a;
   output reg signed [10:0] _ar, _ai;
   
   always @(posedge CLK) begin
      _valid_a <= valid_a;
      _ar <= ar;
      _ai <= ai;
   end
endmodule
