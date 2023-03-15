// Nicholas Palmer | Feb 20, 2023
`timescale 1ns / 1ps

module ROM_TB;
    logic clk, rst;
    logic pc_sel_CONTROL;
    
    always #10 clk = ~clk;

    logic [31:0] pc;
    logic [31:0] inst;
    
    pc PC(clk, rst, (pc_sel_CONTROL ? (32'b0) : (pc+4)), pc);
    async_rom ROM({pc[11:2]}, inst);
    
    initial begin
        clk <= 0; rst <= 0; pc_sel_CONTROL = 0;
        #20;
        rst <= 1;
        #100;
    end
endmodule
