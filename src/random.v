// Random pulse generator
// (C)2024 Pete Siddons
//

`default_nettype none
`timescale 1ns / 1ps

module random (
    input wire clk,
    input  wire reset,
    output reg pulse,
    input wire [7:0] thresh
    );

    reg fb;
    reg [31:0] cnt, level;
    
    always @(posedge clk) begin
    if(reset==1'b1) begin
          cnt = 32'haaaaaaaa;  // 32-bit shift register
       end

      if(reset == 1'b0) begin
        fb <= cnt[31] ^ cnt[21] ^ cnt[1] ^ cnt[0];
        cnt <= {cnt[30:0],fb};
        level <= {8'h00,thresh,12'h000};
        if (cnt<level) begin
           pulse <= 1'b1;
        end
        else begin
             pulse <= 1'b0;
        end
       end	
      end
endmodule
