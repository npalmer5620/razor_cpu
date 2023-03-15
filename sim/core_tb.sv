// Nicholas Palmer | Feb 20, 2023
`timescale 1ns / 1ps

module CORE_TB;
    logic clk, rst;
    
    always #1 clk = ~clk;
    
    core CORE(clk, rst);
    
    initial begin
        clk <= 0; rst <= 0;
        #3;
        rst <= 1;
        #10000;
    end
endmodule
