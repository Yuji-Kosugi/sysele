module fft64(CLK, RST, valid_a, ar, ai, valid_o, xr, xi);
   input 		    CLK, RST, valid_a;
   input signed [10:0] 	    ar, ai;
   output  		    valid_o;
   output signed [10:0] xr, xi;

   reg [1:0] 		    select;
   reg [5:0] 		    count;

   wire 		    valid_a_0, valid_a_1, valid_a_2, valid_a_3;
   wire 		    valid_o_0, valid_o_1, valid_o_2, valid_o_3;
   wire signed [10:0] 	    xr_0, xi_0, xr_1, xi_1, xr_2, xi_2, xr_3, xi_3;

   always @(posedge CLK or negedge RST) begin
      if (RST == 1'b0) begin
	 select <= 2'd0;
	 count <= 6'd0;
      end else begin
	 if (valid_a == 1'b1) begin
	    count <= count + 6'd1;
	 end
	 if (count == 6'd63) begin
	    select <= select + 2'd1;
	 end
      end
   end
	   
   assign valid_a_0 = (valid_a == 1'b1 && select == 2'd0) ? 1'b1 : 1'b0;
   assign valid_a_1 = (valid_a == 1'b1 && select == 2'd1) ? 1'b1 : 1'b0;
   assign valid_a_2 = (valid_a == 1'b1 && select == 2'd2) ? 1'b1 : 1'b0;
   assign valid_a_3 = (valid_a == 1'b1 && select == 2'd3) ? 1'b1 : 1'b0;
   assign valid_o = valid_o_0 | valid_o_1 | valid_o_2 | valid_o_3;
   assign xr = (valid_o_0 == 1'b1) ? xr_0 : ((valid_o_1 == 1'b1) ? xr_1 : ((valid_o_2 == 1'b1) ? xr_2 : xr_3));
   assign xi = (valid_o_0 == 1'b1) ? xi_0 : ((valid_o_1 == 1'b1) ? xi_1 : ((valid_o_2 == 1'b1) ? xi_2 : xi_3));   

   execute execute0(CLK, RST, valid_a_0, ar, ai, valid_o_0, xr_0, xi_0);
   execute execute1(CLK, RST, valid_a_1, ar, ai, valid_o_1, xr_1, xi_1);
   execute execute2(CLK, RST, valid_a_2, ar, ai, valid_o_2, xr_2, xi_2);
   execute execute3(CLK, RST, valid_a_3, ar, ai, valid_o_3, xr_3, xi_3);
endmodule
   
module execute(CLK, RST, valid_a, ar, ai, valid_o, xr, xi);
   input 		    CLK, RST, valid_a;
   input signed [10:0] 	    ar, ai;
   output reg 		    valid_o;
   output reg signed [10:0] xr, xi;

   reg  		    working;
   reg [31:0] 		    count;
   reg signed [28:0] 	    x0r[0:63], x0i[0:63], x1r[0:63], x1i[0:63], x2r[0:63], x2i[0:63], x3r[0:63], x3i[0:63], x4r[0:63], x4i[0:63];
   
   wire [5:0] 		    a0, a1, a2, a3, p0, p1, p2, p3;
   wire [5:0] 		    b0, b1, b2, b3, q0, q1, q2, q3;
   wire [5:0] 		    c0, c1, c2, c3;

   assign a0 = count - 64;
   assign a1 = a0 + 16;
   assign a2 = a0 + 32;
   assign a3 = a0 + 48;
   assign p0 = 0;
   assign p1 = a0;
   assign p2 = a0 + a0;
   assign p3 = a0 + a0 + a0;
   assign b0 = b0_gen(count);
   assign b1 = b0 + 4;
   assign b2 = b0 + 8;
   assign b3 = b0 + 12;
   assign q0 = 0;
   assign q1 = q1_gen(count);
   assign q2 = q1 + q1;
   assign q3 = q1 + q1 + q1;
   assign c0 = count + count + count + count - 384;
   assign c1 = c0 + 1;
   assign c2 = c0 + 2;
   assign c3 = c0 + 3;

   function [31:0] b0_gen;
      input [31:0] 	    count;
      if (count >= 80 && count <= 83) begin
	 b0_gen = count - 80;
      end else if (count >= 84 && count <= 87) begin
	 b0_gen = count - 68;
      end else if (count >= 88 && count <= 91) begin
	 b0_gen = count - 56;
      end else if (count >= 92 && count <= 95) begin
	 b0_gen = count - 44;
      end
   endfunction
   
   function [31:0] q1_gen;
      input [31:0] count;
      if (count >= 80 && count <= 83) begin
	 q1_gen = count + count + count + count - 320;
      end else if (count >= 84 && count <= 87) begin
	 q1_gen = count + count + count + count - 336;
      end else if (count >= 88 && count <= 91) begin
	 q1_gen = count + count + count + count - 352;
      end else if (count >= 92 && count <= 95) begin
	 q1_gen = count + count + count + count - 368;
      end
   endfunction
   
   always @(posedge CLK or negedge RST) begin
      if (RST == 1'b0) begin
	 working <= 1'b0;
	 count <= 32'd0;
	 valid_o <= 1'b0;
      end else begin
	 if (valid_a == 1'b1) begin
	    working <= 1'b1;
	 end
	 if (valid_a == 1'b1 || working == 1'b1) begin
	    if (count >= 0 && count <= 63) begin
	       x0r[count] <= {{18{ar[10]}}, ar};
	       x0i[count] <= {{18{ai[10]}}, ai};
	       count <= count + 32'd1;
	    end else if (count >=64 && count <= 79) begin
	       x1r[a0[5:0]] <= (x0r[a0[5:0]]+x0r[a1[5:0]]+x0r[a2[5:0]]+x0r[a3[5:0]])*cos(p0[5:0])-(x0i[a0[5:0]]+x0i[a1[5:0]]+x0i[a2[5:0]]+x0i[a3[5:0]])*sin(p0[5:0]);
	       x1i[a0[5:0]] <= (x0r[a0[5:0]]+x0r[a1[5:0]]+x0r[a2[5:0]]+x0r[a3[5:0]])*sin(p0[5:0])+(x0i[a0[5:0]]+x0i[a1[5:0]]+x0i[a2[5:0]]+x0i[a3[5:0]])*cos(p0[5:0]);
	       x1r[a1[5:0]] <= (x0r[a0[5:0]]+x0i[a1[5:0]]-x0r[a2[5:0]]-x0i[a3[5:0]])*cos(p1[5:0])-(x0i[a0[5:0]]-x0r[a1[5:0]]-x0i[a2[5:0]]+x0r[a3[5:0]])*sin(p1[5:0]);
	       x1i[a1[5:0]] <= (x0r[a0[5:0]]+x0i[a1[5:0]]-x0r[a2[5:0]]-x0i[a3[5:0]])*sin(p1[5:0])+(x0i[a0[5:0]]-x0r[a1[5:0]]-x0i[a2[5:0]]+x0r[a3[5:0]])*cos(p1[5:0]);
	       x1r[a2[5:0]] <= (x0r[a0[5:0]]-x0r[a1[5:0]]+x0r[a2[5:0]]-x0r[a3[5:0]])*cos(p2[5:0])-(x0i[a0[5:0]]-x0i[a1[5:0]]+x0i[a2[5:0]]-x0i[a3[5:0]])*sin(p2[5:0]);
	       x1i[a2[5:0]] <= (x0r[a0[5:0]]-x0r[a1[5:0]]+x0r[a2[5:0]]-x0r[a3[5:0]])*sin(p2[5:0])+(x0i[a0[5:0]]-x0i[a1[5:0]]+x0i[a2[5:0]]-x0i[a3[5:0]])*cos(p2[5:0]);
	       x1r[a3[5:0]] <= (x0r[a0[5:0]]-x0i[a1[5:0]]-x0r[a2[5:0]]+x0i[a3[5:0]])*cos(p3[5:0])-(x0i[a0[5:0]]+x0r[a1[5:0]]-x0i[a2[5:0]]-x0r[a3[5:0]])*sin(p3[5:0]);
	       x1i[a3[5:0]] <= (x0r[a0[5:0]]-x0i[a1[5:0]]-x0r[a2[5:0]]+x0i[a3[5:0]])*sin(p3[5:0])+(x0i[a0[5:0]]+x0r[a1[5:0]]-x0i[a2[5:0]]-x0r[a3[5:0]])*cos(p3[5:0]);
	       count <= count + 32'd1;	      
	    end else if (count >= 80 && count <= 95) begin
	       x2r[b0[5:0]] <= (x1r[b0[5:0]]+x1r[b1[5:0]]+x1r[b2[5:0]]+x1r[b3[5:0]])*cos(q0)-(x1i[b0[5:0]]+x1i[b1[5:0]]+x1i[b2[5:0]]+x1i[b3[5:0]])*sin(q0);
	       x2i[b0[5:0]] <= (x1r[b0[5:0]]+x1r[b1[5:0]]+x1r[b2[5:0]]+x1r[b3[5:0]])*sin(q0)+(x1i[b0[5:0]]+x1i[b1[5:0]]+x1i[b2[5:0]]+x1i[b3[5:0]])*cos(q0);
	       x2r[b1[5:0]] <= (x1r[b0[5:0]]+x1i[b1[5:0]]-x1r[b2[5:0]]-x1i[b3[5:0]])*cos(q1)-(x1i[b0[5:0]]-x1r[b1[5:0]]-x1i[b2[5:0]]+x1r[b3[5:0]])*sin(q1);
	       x2i[b1[5:0]] <= (x1r[b0[5:0]]+x1i[b1[5:0]]-x1r[b2[5:0]]-x1i[b3[5:0]])*sin(q1)+(x1i[b0[5:0]]-x1r[b1[5:0]]-x1i[b2[5:0]]+x1r[b3[5:0]])*cos(q1);
	       x2r[b2[5:0]] <= (x1r[b0[5:0]]-x1r[b1[5:0]]+x1r[b2[5:0]]-x1r[b3[5:0]])*cos(q2)-(x1i[b0[5:0]]-x1i[b1[5:0]]+x1i[b2[5:0]]-x1i[b3[5:0]])*sin(q2);
	       x2i[b2[5:0]] <= (x1r[b0[5:0]]-x1r[b1[5:0]]+x1r[b2[5:0]]-x1r[b3[5:0]])*sin(q2)+(x1i[b0[5:0]]-x1i[b1[5:0]]+x1i[b2[5:0]]-x1i[b3[5:0]])*cos(q2);
	       x2r[b3[5:0]] <= (x1r[b0[5:0]]-x1i[b1[5:0]]-x1r[b2[5:0]]+x1i[b3[5:0]])*cos(q3)-(x1i[b0[5:0]]+x1r[b1[5:0]]-x1i[b2[5:0]]-x1r[b3[5:0]])*sin(q3);
	       x2i[b3[5:0]] <= (x1r[b0[5:0]]-x1i[b1[5:0]]-x1r[b2[5:0]]+x1i[b3[5:0]])*sin(q3)+(x1i[b0[5:0]]+x1r[b1[5:0]]-x1i[b2[5:0]]-x1r[b3[5:0]])*cos(q3);
	       count <= count + 32'd1;	       
	    end else if (count >= 96 && count <= 111) begin
	       x3r[c0] <= x2r[c0]+x2r[c1]+x2r[c2]+x2r[c3];
	       x3i[c0] <= x2i[c0]+x2i[c1]+x2i[c2]+x2i[c3];
	       x3r[c1] <= x2r[c0]+x2i[c1]-x2r[c2]-x2i[c3];
	       x3i[c1] <= x2i[c0]-x2r[c1]-x2i[c2]+x2r[c3];
	       x3r[c2] <= x2r[c0]-x2r[c1]+x2r[c2]-x2r[c3];
	       x3i[c2] <= x2i[c0]-x2i[c1]+x2i[c2]-x2i[c3];
	       x3r[c3] <= x2r[c0]-x2i[c1]-x2r[c2]+x2i[c3];
	       x3i[c3] <= x2i[c0]+x2r[c1]-x2i[c2]-x2r[c3];
	       count <= count + 32'd1;	       
	    end else if (count == 112) begin
	       x4r[0]  <= x3r[0];  x4i[0]  <= x3i[0];
	       x4r[1]  <= x3r[16]; x4i[1]  <= x3i[16]; 
	       x4r[2]  <= x3r[32]; x4i[2]  <= x3i[32]; 
	       x4r[3]  <= x3r[48]; x4i[3]  <= x3i[48]; 
	       x4r[4]  <= x3r[4];  x4i[4]  <= x3i[4];  
	       x4r[5]  <= x3r[20]; x4i[5]  <= x3i[20]; 
	       x4r[6]  <= x3r[36]; x4i[6]  <= x3i[36]; 
	       x4r[7]  <= x3r[52]; x4i[7]  <= x3i[52]; 
	       x4r[8]  <= x3r[8];  x4i[8]  <= x3i[8];  
	       x4r[9]  <= x3r[24]; x4i[9]  <= x3i[24]; 
	       x4r[10] <= x3r[40]; x4i[10] <= x3i[40]; 
	       x4r[11] <= x3r[56]; x4i[11] <= x3i[56]; 
	       x4r[12] <= x3r[12]; x4i[12] <= x3i[12]; 
	       x4r[13] <= x3r[28]; x4i[13] <= x3i[28]; 
	       x4r[14] <= x3r[44]; x4i[14] <= x3i[44]; 
	       x4r[15] <= x3r[60]; x4i[15] <= x3i[60]; 
	       x4r[16] <= x3r[1];  x4i[16] <= x3i[1];  
	       x4r[17] <= x3r[17]; x4i[17] <= x3i[17]; 
	       x4r[18] <= x3r[33]; x4i[18] <= x3i[33]; 
	       x4r[19] <= x3r[49]; x4i[19] <= x3i[49]; 
	       x4r[20] <= x3r[5];  x4i[20] <= x3i[5];  
	       x4r[21] <= x3r[21]; x4i[21] <= x3i[21]; 
	       x4r[22] <= x3r[37]; x4i[22] <= x3i[37]; 
	       x4r[23] <= x3r[53]; x4i[23] <= x3i[53]; 
	       x4r[24] <= x3r[9];  x4i[24] <= x3i[9];  
	       x4r[25] <= x3r[25]; x4i[25] <= x3i[25]; 
	       x4r[26] <= x3r[41]; x4i[26] <= x3i[41]; 
	       x4r[27] <= x3r[57]; x4i[27] <= x3i[57]; 
	       x4r[28] <= x3r[13]; x4i[28] <= x3i[13]; 
	       x4r[29] <= x3r[29]; x4i[29] <= x3i[29]; 
	       x4r[30] <= x3r[45]; x4i[30] <= x3i[45]; 
	       x4r[31] <= x3r[61]; x4i[31] <= x3i[61]; 
	       x4r[32] <= x3r[2];  x4i[32] <= x3i[2];  
	       x4r[33] <= x3r[18]; x4i[33] <= x3i[18]; 
	       x4r[34] <= x3r[34]; x4i[34] <= x3i[34]; 
	       x4r[35] <= x3r[50]; x4i[35] <= x3i[50]; 
	       x4r[36] <= x3r[6];  x4i[36] <= x3i[6];  
	       x4r[37] <= x3r[22]; x4i[37] <= x3i[22]; 
	       x4r[38] <= x3r[38]; x4i[38] <= x3i[38]; 
	       x4r[39] <= x3r[54]; x4i[39] <= x3i[54]; 
	       x4r[40] <= x3r[10]; x4i[40] <= x3i[10]; 
	       x4r[41] <= x3r[26]; x4i[41] <= x3i[26]; 
	       x4r[42] <= x3r[42]; x4i[42] <= x3i[42]; 
	       x4r[43] <= x3r[58]; x4i[43] <= x3i[58]; 
	       x4r[44] <= x3r[14]; x4i[44] <= x3i[14]; 
	       x4r[45] <= x3r[30]; x4i[45] <= x3i[30]; 
	       x4r[46] <= x3r[46]; x4i[46] <= x3i[46]; 
	       x4r[47] <= x3r[62]; x4i[47] <= x3i[62]; 
	       x4r[48] <= x3r[3];  x4i[48] <= x3i[3];  
	       x4r[49] <= x3r[19]; x4i[49] <= x3i[19]; 
	       x4r[50] <= x3r[35]; x4i[50] <= x3i[35]; 
	       x4r[51] <= x3r[51]; x4i[51] <= x3i[51]; 
	       x4r[52] <= x3r[7];  x4i[52] <= x3i[7];  
	       x4r[53] <= x3r[23]; x4i[53] <= x3i[23]; 
	       x4r[54] <= x3r[39]; x4i[54] <= x3i[39]; 
	       x4r[55] <= x3r[55]; x4i[55] <= x3i[55]; 
	       x4r[56] <= x3r[11]; x4i[56] <= x3i[11]; 
	       x4r[57] <= x3r[27]; x4i[57] <= x3i[27]; 
	       x4r[58] <= x3r[43]; x4i[58] <= x3i[43]; 
	       x4r[59] <= x3r[59]; x4i[59] <= x3i[59]; 
	       x4r[60] <= x3r[15]; x4i[60] <= x3i[15]; 
	       x4r[61] <= x3r[31]; x4i[61] <= x3i[31]; 
	       x4r[62] <= x3r[47]; x4i[62] <= x3i[47]; 
	       x4r[63] <= x3r[63]; x4i[63] <= x3i[63];
	       count <= count + 32'd1;
	    end else if (count >= 113 && count <= 176) begin
	       valid_o <= 1'b1;
	       xr <= x4r[count - 113][28:18];
	       xi <= x4i[count - 113][28:18];
	       count <= count + 32'd1;
	    end else if (count == 177) begin
	       working <= 1'b0;
	       count <= 32'd0;
	       valid_o <= 1'b0;
	    end
	 end
      end
   end

   function signed [9:0] cos;
      input [5:0] in;
      case (in)
	6'd0  : cos = 10'b0111111111;
	6'd1  : cos = 10'b0111111110;
	6'd2  : cos = 10'b0111110110;
	6'd3  : cos = 10'b0111101010;
	6'd4  : cos = 10'b0111011001;
	6'd5  : cos = 10'b0111000100;
	6'd6  : cos = 10'b0110101010;
	6'd7  : cos = 10'b0110001100;
	6'd8  : cos = 10'b0101101010;
	6'd9  : cos = 10'b0101000101;
	6'd10 : cos = 10'b0100011100;
	6'd11 : cos = 10'b0011110001;
	6'd12 : cos = 10'b0011000100;
	6'd13 : cos = 10'b0010010101;
	6'd14 : cos = 10'b0001100100;
	6'd15 : cos = 10'b0000110010;
	6'd16 : cos = 10'b0000000000;
	6'd17 : cos = 10'b1111001110;
	6'd18 : cos = 10'b1110011100;
	6'd19 : cos = 10'b1101101011;
	6'd20 : cos = 10'b1100111100;
	6'd21 : cos = 10'b1100001111;
	6'd22 : cos = 10'b1011100100;
	6'd23 : cos = 10'b1010111011;
	6'd24 : cos = 10'b1010010110;
	6'd25 : cos = 10'b1001110100;
	6'd26 : cos = 10'b1001010110;
	6'd27 : cos = 10'b1000111100;
	6'd28 : cos = 10'b1000100111;
	6'd29 : cos = 10'b1000010110;
	6'd30 : cos = 10'b1000001010;
	6'd31 : cos = 10'b1000000010;
	6'd32 : cos = 10'b1000000000;
	6'd33 : cos = 10'b1000000010;
	6'd34 : cos = 10'b1000001010;
	6'd35 : cos = 10'b1000010110;
	6'd36 : cos = 10'b1000100111;
	6'd37 : cos = 10'b1000111100;
	6'd38 : cos = 10'b1001010110;
	6'd39 : cos = 10'b1001110100;
	6'd40 : cos = 10'b1010010110;
	6'd41 : cos = 10'b1010111011;
	6'd42 : cos = 10'b1011100100;
	6'd43 : cos = 10'b1100001111;
	6'd44 : cos = 10'b1100111100;
	6'd45 : cos = 10'b1101101011;
	6'd46 : cos = 10'b1110011100;
	6'd47 : cos = 10'b1111001110;
	6'd48 : cos = 10'b0000000000;
	6'd49 : cos = 10'b0000110010;
	6'd50 : cos = 10'b0001100100;
	6'd51 : cos = 10'b0010010101;
	6'd52 : cos = 10'b0011000100;
	6'd53 : cos = 10'b0011110001;
	6'd54 : cos = 10'b0100011100;
	6'd55 : cos = 10'b0101000101;
	6'd56 : cos = 10'b0101101010;
	6'd57 : cos = 10'b0110001100;
	6'd58 : cos = 10'b0110101010;
	6'd59 : cos = 10'b0111000100;
	6'd60 : cos = 10'b0111011001;
	6'd61 : cos = 10'b0111101010;
	6'd62 : cos = 10'b0111110110;
	6'd63 : cos = 10'b0111111110;
      endcase
   endfunction

   function signed [9:0] sin;
      input [5:0] in;
      case (in)
	6'd0  : sin = 10'b0000000000;
	6'd1  : sin = 10'b1111001110;
	6'd2  : sin = 10'b1110011100;
	6'd3  : sin = 10'b1101101011;
	6'd4  : sin = 10'b1100111100;
	6'd5  : sin = 10'b1100001111;
	6'd6  : sin = 10'b1011100100;
	6'd7  : sin = 10'b1010111011;
	6'd8  : sin = 10'b1010010110;
	6'd9  : sin = 10'b1001110100;
	6'd10 : sin = 10'b1001010110;
	6'd11 : sin = 10'b1000111100;
	6'd12 : sin = 10'b1000100111;
	6'd13 : sin = 10'b1000010110;
	6'd14 : sin = 10'b1000001010;
	6'd15 : sin = 10'b1000000010;
	6'd16 : sin = 10'b1000000000;
	6'd17 : sin = 10'b1000000010;
	6'd18 : sin = 10'b1000001010;
	6'd19 : sin = 10'b1000010110;
	6'd20 : sin = 10'b1000100111;
	6'd21 : sin = 10'b1000111100;
	6'd22 : sin = 10'b1001010110;
	6'd23 : sin = 10'b1001110100;
	6'd24 : sin = 10'b1010010110;
	6'd25 : sin = 10'b1010111011;
	6'd26 : sin = 10'b1011100100;
	6'd27 : sin = 10'b1100001111;
	6'd28 : sin = 10'b1100111100;
	6'd29 : sin = 10'b1101101011;
	6'd30 : sin = 10'b1110011100;
	6'd31 : sin = 10'b1111001110;
	6'd32 : sin = 10'b0000000000;
	6'd33 : sin = 10'b0000110010;
	6'd34 : sin = 10'b0001100100;
	6'd35 : sin = 10'b0010010101;
	6'd36 : sin = 10'b0011000100;
	6'd37 : sin = 10'b0011110001;
	6'd38 : sin = 10'b0100011100;
	6'd39 : sin = 10'b0101000101;
	6'd40 : sin = 10'b0101101010;
	6'd41 : sin = 10'b0110001100;
	6'd42 : sin = 10'b0110101010;
	6'd43 : sin = 10'b0111000100;
	6'd44 : sin = 10'b0111011001;
	6'd45 : sin = 10'b0111101010;
	6'd46 : sin = 10'b0111110110;
	6'd47 : sin = 10'b0111111110;
	6'd48 : sin = 10'b0111111111;
	6'd49 : sin = 10'b0111111110;
	6'd50 : sin = 10'b0111110110;
	6'd51 : sin = 10'b0111101010;
	6'd52 : sin = 10'b0111011001;
	6'd53 : sin = 10'b0111000100;
	6'd54 : sin = 10'b0110101010;
	6'd55 : sin = 10'b0110001100;
	6'd56 : sin = 10'b0101101010;
	6'd57 : sin = 10'b0101000101;
	6'd58 : sin = 10'b0100011100;
	6'd59 : sin = 10'b0011110001;
	6'd60 : sin = 10'b0011000100;
	6'd61 : sin = 10'b0010010101;
	6'd62 : sin = 10'b0001100100;
	6'd63 : sin = 10'b0000110010;
      endcase
   endfunction
endmodule
