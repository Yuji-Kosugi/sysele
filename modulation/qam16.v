
module qam16
  (
   input                CLK,
   input                RST,

   input                valid_i,
   input [3:0]          data_i,

   output reg              valid_x,
   output reg signed [10:0] xr,
   output reg signed [10:0] xi
   );

  always @(posedge CLK or negedge RST) begin
    if (RST == 1'b0) begin
      valid_x <= 1'b0;
    end else if (valid_i == 1'b1) begin
      valid_x <= 1'b1;
      case (data_i)
        4'b0000 : begin xr <= 11'd6; xi <= 11'd6; end
        4'b0001 : begin xr <= 11'd6; xi <= 11'd2; end
        4'b0010 : begin xr <= 11'd2; xi <= 11'd6; end
        4'b0011 : begin xr <= 11'd2; xi <= 11'd2; end
        4'b0100 : begin xr <= 11'd6; xi <= -11'd6; end
        4'b0101 : begin xr <= 11'd6; xi <= -11'd2; end
        4'b0110 : begin xr <= 11'd2; xi <= -11'd6; end
        4'b0111 : begin xr <= 11'd2; xi <= -11'd2; end
        4'b1000 : begin xr <= -11'd6; xi <= 11'd6; end
        4'b1001 : begin xr <= -11'd6; xi <= 11'd2; end
        4'b1010 : begin xr <= -11'd2; xi <= 11'd6; end
        4'b1011 : begin xr <= -11'd2; xi <= 11'd2; end
        4'b1100 : begin xr <= -11'd6; xi <= -11'd6; end
        4'b1101 : begin xr <= -11'd6; xi <= -11'd2; end
        4'b1110 : begin xr <= -11'd2; xi <= -11'd6; end
        4'b1111 : begin xr <= -11'd2; xi <= -11'd2; end
      endcase
    end else if (valid_i == 1'b0) begin
      valid_x <= 1'b0;
    end
  end
endmodule
