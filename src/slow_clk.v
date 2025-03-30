module slow_clk (
    input wire reset,
    input wire clk,
    output reg clock
    );

    reg [13:0] divider;
    
    
    always @(posedge clk) begin
       if(reset) begin
          divider <=0;
          end else begin
              divider <= divider + 1;
              end
          clock <= divider[13];
   end
endmodule
