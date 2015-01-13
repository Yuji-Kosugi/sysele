module viterbi(CLK, RST, valid_i, data_i, valid_o, data_o);
   input       CLK, RST, valid_i;
   input [1:0] data_i;
   output      valid_o, data_o;

   reg [1:0]   select;
   reg [5:0]   count;
   
   wire        valid_i_0, valid_i_1, valid_i_2, valid_i_3;
   wire        valid_o_0, valid_o_1, valid_o_2, valid_o_3;
   wire        data_o_0, data_o_1, data_o_2, data_o_3;
   
   always @(posedge CLK or negedge RST) begin
      if (RST == 1'b0) begin
	 select <= 2'd0;
	 count <= 6'd0;
      end else begin
	 if (valid_i == 1'b1) begin
	    count <= count + 6'd1;
	 end
	 if (count == 6'd63) begin
	    select <= select + 2'd1;
	 end
      end
   end

   assign valid_i_0 = (valid_i == 1'b1 && select == 2'd0) ? 1'b1 : 1'b0;
   assign valid_i_1 = (valid_i == 1'b1 && select == 2'd1) ? 1'b1 : 1'b0;
   assign valid_i_2 = (valid_i == 1'b1 && select == 2'd2) ? 1'b1 : 1'b0;
   assign valid_i_3 = (valid_i == 1'b1 && select == 2'd3) ? 1'b1 : 1'b0;
   assign valid_o = valid_o_0 | valid_o_1 | valid_o_2 | valid_o_3;
   assign data_o = (valid_o_0 == 1'b1) ? data_o_0 : ((valid_o_1 == 1'b1) ? data_o_1 : ((valid_o_2 == 1'b1) ? data_o_2 : data_o_3));

   execute execute0(CLK, RST, valid_i_0, data_i, valid_o_0, data_o_0);
   execute execute1(CLK, RST, valid_i_1, data_i, valid_o_1, data_o_1);
   execute execute2(CLK, RST, valid_i_2, data_i, valid_o_2, data_o_2);
   execute execute3(CLK, RST, valid_i_3, data_i, valid_o_3, data_o_3);
endmodule
  
module execute(CLK, RST, valid_i, data_i, valid_o, data_o);
   input       CLK, RST, valid_i;
   input [1:0] data_i;
   output reg  valid_o, data_o;

   reg 	       working;
   reg [31:0]  count, sum00, sum01, sum10, sum11;
   reg [1:0]   pre00[0:63], pre01[0:63], pre10[0:63], pre11[0:63];
   reg [1:0]   state;
   reg [63:0]  data;
   
   always @(posedge CLK or negedge RST) begin
      if (RST == 1'b0) begin
	 working <= 1'b0;
	 count <= 32'd0;
	 valid_o <= 1'b0;
	 sum00 <= 32'd0;
	 sum01 <= 32'd0;
	 sum10 <= 32'd0;
	 sum11 <= 32'd0;
      end else begin
	 if (valid_i == 1'b1) begin
	    working <= 1'b1;
	 end
	 if (valid_i == 1'b1 || working == 1'b1) begin
	    if (count == 0) begin
	       sum00 <= sum00 +  data_i[0] +  data_i[1];
	       sum10 <= sum00 + {31'd0, ~data_i[0]} + {31'd0, ~data_i[1]};
	       pre00[count] <= 2'b00;
	       pre10[count] <= 2'b00;
	       count <= count + 32'd1;
	    end else if (count == 1) begin
	       sum00 <= sum00 + {31'd0,  data_i[0]} + {31'd0,  data_i[1]};
	       sum01 <= sum10 + {31'd0,  data_i[0]} + {31'd0, ~data_i[1]};
	       sum10 <= sum00 + {31'd0, ~data_i[0]} + {31'd0, ~data_i[1]};
  	       sum11 <= sum10 + {31'd0, ~data_i[0]} + {31'd0,  data_i[1]};
	       pre00[count] <= 2'b00;
	       pre01[count] <= 2'b10;
	       pre10[count] <= 2'b00;
	       pre11[count] <= 2'b10;
	       count <= count + 32'd1;
	    end else if (count >= 2 && count <= 63) begin
	       sum00 <= (sum00 + {31'd0,  data_i[0]} + {31'd0,  data_i[1]} < sum01 + {31'd0, ~data_i[0]} + {31'd0, ~data_i[1]}) ? sum00 + {31'd0,  data_i[0]} + {31'd0,  data_i[1]} : sum01 + {31'd0, ~data_i[0]} + {31'd0, ~data_i[1]};
	       sum01 <= (sum10 + {31'd0,  data_i[0]} + {31'd0, ~data_i[1]} < sum11 + {31'd0, ~data_i[0]} + {31'd0,  data_i[1]}) ? sum10 + {31'd0,  data_i[0]} + {31'd0, ~data_i[1]} : sum11 + {31'd0, ~data_i[0]} + {31'd0,  data_i[1]};
	       sum10 <= (sum00 + {31'd0, ~data_i[0]} + {31'd0, ~data_i[1]} < sum01 + {31'd0,  data_i[0]} + {31'd0,  data_i[1]}) ? sum00 + {31'd0, ~data_i[0]} + {31'd0, ~data_i[1]} : sum01 + {31'd0,  data_i[0]} + {31'd0,  data_i[1]};
  	       sum11 <= (sum10 + {31'd0, ~data_i[0]} + {31'd0,  data_i[1]} < sum11 + {31'd0,  data_i[0]} + {31'd0, ~data_i[1]}) ? sum10 + {31'd0, ~data_i[0]} + {31'd0,  data_i[1]} : sum11 + {31'd0,  data_i[0]} + {31'd0, ~data_i[1]};
	       pre00[count] <= (sum00 + {31'd0,  data_i[0]} + {31'd0,  data_i[1]} < sum01 + {31'd0, ~data_i[0]} + {31'd0, ~data_i[1]}) ? 2'b00 : 2'b01;
	       pre01[count] <= (sum10 + {31'd0,  data_i[0]} + {31'd0, ~data_i[1]} < sum11 + {31'd0, ~data_i[0]} + {31'd0,  data_i[1]}) ? 2'b10 : 2'b11;
	       pre10[count] <= (sum00 + {31'd0, ~data_i[0]} + {31'd0, ~data_i[1]} < sum01 + {31'd0,  data_i[0]} + {31'd0,  data_i[1]}) ? 2'b00 : 2'b01;
	       pre11[count] <= (sum10 + {31'd0, ~data_i[0]} + {31'd0,  data_i[1]} < sum11 + {31'd0,  data_i[0]} + {31'd0, ~data_i[1]}) ? 2'b10 : 2'b11;
	       count <= count + 32'd1;
	    end else if (count == 64) begin
	       state <= min(sum00, sum01, sum10, sum11);
	       count <= count + 32'd1;
	    end else if (count >= 65 && count <= 128) begin
	       data[128 - count] <= (state == 2'b00 || state == 2'b01) ? 0 : 1;
	       state <= (state == 2'b00) ? pre00[128 - count] : ((state == 2'b01) ? pre01[128 - count] : ((state == 2'b10) ? pre10[128 - count] : pre11[128 - count]));
	       count <= count + 32'd1;
	    end	else if (count >= 129 && count <= 192) begin
	       valid_o <= 1'b1;
	       data_o <= data[count - 129];
	       count <= count + 32'd1;
	    end else if (count == 193) begin
	       working <= 1'b0;
	       count <= 32'd0;
	       valid_o <= 1'b0;
	       sum00 <= 32'd0;
	       sum01 <= 32'd0;
	       sum10 <= 32'd0;
	       sum11 <= 32'd0;
	    end
	 end
      end
   end

   function [1:0] min;
      input [31:0] sum00, sum01, sum10, sum11;
      begin
	 if (sum00 <= sum01 && sum01 <= sum10 && sum10 <= sum11) min = 2'b00;
	 else if (sum00 <= sum01 && sum01 <= sum11 && sum11 <= sum10) min = 2'b00;
	 else if (sum00 <= sum10 && sum10 <= sum01 && sum01 <= sum11) min = 2'b00;
	 else if (sum00 <= sum10 && sum10 <= sum11 && sum11 <= sum01) min = 2'b00;
	 else if (sum00 <= sum11 && sum11 <= sum01 && sum01 <= sum10) min = 2'b00;
	 else if (sum00 <= sum11 && sum11 <= sum10 && sum10 <= sum01) min = 2'b00;

	 else if (sum01 <= sum00 && sum00 <= sum10 && sum10 <= sum11) min = 2'b01;
	 else if (sum01 <= sum00 && sum00 <= sum11 && sum11 <= sum10) min = 2'b01;
	 else if (sum01 <= sum10 && sum10 <= sum00 && sum00 <= sum11) min = 2'b01;
	 else if (sum01 <= sum10 && sum10 <= sum11 && sum11 <= sum00) min = 2'b01;
	 else if (sum01 <= sum11 && sum11 <= sum00 && sum00 <= sum10) min = 2'b01;
	 else if (sum01 <= sum11 && sum11 <= sum10 && sum10 <= sum00) min = 2'b01;      

	 else if (sum10 <= sum00 && sum00 <= sum01 && sum01 <= sum11) min = 2'b10;
	 else if (sum10 <= sum00 && sum00 <= sum11 && sum11 <= sum01) min = 2'b10;
	 else if (sum10 <= sum01 && sum01 <= sum00 && sum00 <= sum11) min = 2'b10;
	 else if (sum10 <= sum01 && sum01 <= sum11 && sum11 <= sum00) min = 2'b10;
	 else if (sum10 <= sum11 && sum11 <= sum00 && sum00 <= sum01) min = 2'b10;
	 else if (sum10 <= sum11 && sum11 <= sum01 && sum01 <= sum00) min = 2'b10;

	 else if (sum11 <= sum00 && sum00 <= sum01 && sum01 <= sum10) min = 2'b11;
	 else if (sum11 <= sum00 && sum00 <= sum10 && sum10 <= sum01) min = 2'b11;
	 else if (sum11 <= sum01 && sum01 <= sum00 && sum00 <= sum10) min = 2'b11;
	 else if (sum11 <= sum01 && sum01 <= sum10 && sum00 <= sum00) min = 2'b11;
	 else if (sum11 <= sum10 && sum10 <= sum00 && sum00 <= sum01) min = 2'b11;
	 else if (sum11 <= sum10 && sum10 <= sum01 && sum01 <= sum00) min = 2'b11;
      end
   endfunction
endmodule
