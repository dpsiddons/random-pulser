`default_nettype none
`timescale 1ns/1ns

module oneshot #(
   parameter TIME = 30
   )(
   input wire clk,
   input wire reset,
   input wire pulse,
   output reg pout
   );

   reg [4:0] counter;  
   reg pulse_d; // Delayed version of pulse for edge detection

   always @(posedge clk or posedge reset) begin
      if (reset) begin
         counter <= 0;
         pout <= 1'b0;
         pulse_d <= 1'b0;
      end else begin
         pulse_d <= pulse; // Store previous pulse state

         // Detect rising edge of pulse
         if (pulse && !pulse_d) begin 
            counter <= TIME;
            pout <= 1'b1;
         end else if (counter != 0) begin
            counter <= counter - 1;
         end else begin
            pout <= 1'b0;
         end
      end
   end

endmodule
