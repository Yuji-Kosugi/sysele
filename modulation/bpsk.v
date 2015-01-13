
module bpsk
  (
   input                CLK,
   input                RST,

   input                valid_i,
   input                data_i,

   output reg           valid_x,
   output reg signed [10:0] xr,
   output reg signed [10:0] xi
   );

  always @(posedge CLK or negedge RST) begin
    if (RST == 1'b0) begin
      valid_x <= 1'b0;
    end else if (valid_i == 1'b1) begin
      valid_x <= 1'b1;
      if (data_i == 1'b0) begin
        xr <= -11'd8;
      end else if (data_i == 1'b1) begin
        xr <= 11'd8;
      end
      xi <= 11'd0;
    end else begin
      valid_x <= 1'b0;
    end
  end
endmodule
