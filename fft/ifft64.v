module ifft64(CLK, RST, valid_a, ar, ai, valid_o, xr, xi);
   input 		CLK, RST, valid_a;
   input signed [10:0] 	ar, ai;
   output 		valid_o;
   output signed [10:0] xr, xi;

   wire signed [10:0] 	_ar, _ai, _xr, _xi;

   assign _ar = ar;
   assign _ai = -ai;
   assign xr = _xr / 64;
   assign xi = -_xi / 64;
   
   fft64 _fft64(CLK, RST, valid_a, _ar, _ai, valid_o, _xr, _xi);
endmodule
