
module qam16_inv
  (
   input               CLK,
   input               RST,

   input               valid_i,
   input signed [10:0] ar,
   input signed [10:0] ai,

   output reg             valid_x,
   output reg [3:0]        x
   );

  always @(posedge CLK or negedge RST) begin
    if (RST == 1'b0) begin
      valid_x <= 1'b0;
    end else if (valid_i == 1'b1) begin
      valid_x <= 1'b1;
      if (ar >= 16 && ai >= 16) begin
        x <= 4'b0000;
      end else if (ar >= 16 && ai >= 0 && ai < 16) begin
        x <= 4'b0001;
      end else if (ar >= 0 && ar < 16 && ai > 16) begin
        x <= 4'b0010;
      end else if (ar >= 0 && ar < 16 && ai >= 0 && ai < 16) begin
        x <= 4'b0011;
      end else if (ar >= 16 && ai < -16) begin
        x <= 4'b0100;
      end else if (ar >= 16 && ai >= -16 && ai < 0) begin
        x <= 4'b0101;
      end else if (ar >= 0 && ar < 16 && ai < -16) begin
        x <= 4'b0110;
      end else if (ar >= 0 && ar < 16 && ai >= -16 && ai < 0) begin
        x <= 4'b0111;
      end else if (ar < -16 && ai >= 16) begin
        x <= 4'b1000;
      end else if (ar < -16 && ai >= 0 && ai < 16) begin
        x <= 4'b1001;
      end else if (ar >= -16 && ar < 0 && ai >= 16) begin
        x <= 4'b1010;
      end else if (ar >= -16 && ar < 0 && ai >= 0 && ai < 16) begin
        x <= 4'b1011;
      end else if (ar < -16 && ai < -16) begin
        x <= 4'b1100;
      end else if (ar < -16 && ai >= -16 && ai < 0) begin
        x <= 4'b1101;
      end else if (ar >= -16 && ar < 0 && ai < -16) begin
        x <= 4'b1110;
      end else if (ar >= -16 && ar < 0 && ai >= -16 && ai < 0) begin
        x <= 4'b1111;
      end
    end else if (valid_i == 1'b0) begin
      valid_x <= 1'b0;
    end
  end
endmodule
