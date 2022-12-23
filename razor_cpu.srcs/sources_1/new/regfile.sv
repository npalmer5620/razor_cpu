`timescale 1ns / 1ps

module regfile(
    input bit clk,
    input bit we,
    input logic [4:0] rda1, rda2, wra,
    input logic [63:0] wrd,
    output logic [63:0] rd1, rd2);
    
    logic [63:0] regs [0:31];
    
    always_comb begin
        rd1 = regs[rda1];
        rd2 = regs[rda2];
    end
    
    always_ff @(posedge clk) begin
        if (we) begin
            regs[wra] <= wrd;
        end
    end
    
    
endmodule
