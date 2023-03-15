// Nicholas Palmer | March 7, 2023
`timescale 1ns / 1ps

module BUS_TB;
    logic clk, rst;
    logic [3:0] write_mask;
    logic [31:0] addr, d_write, d_read;
    
    always #10 clk = ~clk;
    
    bus_controller BUS(clk, rst, write_mask, addr, d_write, d_read);
    
    initial begin
        clk <= 0; rst <= 1; write_mask <= 4'b0000; addr <= 32'b0; d_write <= 32'b0;
        #20;
        rst <= 0; addr <= 32'h10000000; write_mask <= 4'b0011; d_write <= 32'hffffffff;
        #10;
        write_mask <= 4'b0000; d_write <= 32'd18;
        #100; 
        rst <= 1;
        #10;
        rst <= 0;
        #100;
    end
endmodule
