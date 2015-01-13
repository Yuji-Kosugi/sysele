module ifft64
  (
   input         CLK,
   input 	 RST,
   
   input 	 valid_a,
   input [10:0]  ar,
   input [10:0]  ai,
   
   output 	 valid_o,
   output [10:0] xr,
   output [10:0] xi
   );

   wire [10:0] 	 _ar, _ai, _xr, _xi;

   assign _ar = ar;
   assign _ai = -ai;
   assign xr = _xr/64;
   assign xi = -_xi/64;

   fft64 _fft64(CLK, RST, valid_a, _ar, _ai, valid_o, _xr, _xi);
   
endmodule
