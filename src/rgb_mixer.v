`default_nettype none
`timescale 1ns/1ns
module rgb_mixer (
    input wire clk,
    input wire reset,
    output wire clock0,
    input wire enc0_a,
    input wire enc0_b,
    output wire pwm0_out,
    output wire pulse0,
    output wire pout0,
    output wire [3:0] leds
);
    wire enc0_a_db, enc0_b_db;
    wire [7:0] enc0;
//    wire slow_clk0;
//    wire [31:0] thresh0;
//    wire pulse0;
//    wire pout0;

    slow_clk slow_clk0(.reset(reset), .clk(clk), .clock(clock0));
    // debouncers, 2 for each encoder
    debounce #(.HIST_LEN(8)) debounce0_a(.clk(clk), .reset(reset), .slow_clk(clock0), .button(enc0_a), .debounced(enc0_a_db));
    debounce #(.HIST_LEN(8)) debounce0_b(.clk(clk), .reset(reset), .slow_clk(clock0), .button(enc0_b), .debounced(enc0_b_db));

    // encoders
    encoder #(.WIDTH(8)) encoder0(.clk(clk), .reset(reset), .a(enc0_a_db), .b(enc0_b_db), .value(enc0), .leds(leds) );

    // pwm modules
    pwm #(.WIDTH(8)) pwm0(.clk(clk), .reset(reset), .out(pwm0_out), .level(enc0) );

    random random0(.clk(clk), .reset(reset), .pulse(pulse0), .thresh(enc0));
    
    oneshot #(.TIME(10)) oneshot0(.clk(clk), .reset(reset), .pulse(pulse0), .pout(pout0));
endmodule
