
module qpsk_inv
  (
   input               CLK,
   input               RST,

   input               valid_i,
   input signed [10:0] ar,
   input signed [10:0] ai,

   output reg          valid_x,
   output reg [1:0]    x
   );

  always @(posedge CLK or negedge RST) begin
    if (RST == 1'b0) begin
      valid_x <= 1'b0;
    end else if (valid_i == 1'b1) begin
      valid_x <= 1'b1;
      if (ar >=0 && ai >=0) begin
        x <= 2'b00;
      end else if (ar >= 0 && ai < 0) begin
        x <= 2'b01;
      end else if (ar < 0 && ai >= 0) begin
        x <= 2'b10;
      end else if (ar < 0 && ai < 0) begin
        x <= 2'b11;
      end
    end else if (valid_i == 1'b0) begin
      valid_x <= 1'b0;
    end
  end
endmodule
