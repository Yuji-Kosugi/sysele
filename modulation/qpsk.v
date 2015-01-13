
module qpsk
  (
   input                CLK,
   input                RST,

   input                valid_i,
   input [1:0]          data_i,

   output reg           valid_x,
   output reg signed [10:0] xr,
   output reg signed [10:0] xi
   );

  always @(posedge CLK or negedge RST) begin
    if (RST == 1'b0) begin
      valid_x <= 1'b0;
    end else if (valid_i == 1'b1) begin
      valid_x <= 1'b1;
      case (data_i)
        2'b00 : begin xr <= 11'd8; xi <= 11'd8; end
        2'b01 : begin xr <= 11'd8; xi <= -11'd8; end
        2'b10 : begin xr <= -11'd8; xi <= 11'd8; end
        2'b11 : begin xr <= -11'd8; xi <= -11'd8; end
      endcase
    end else if (valid_i == 1'b0) begin
      valid_x <= 1'b0;
    end
  end
endmodule
