`timescale 1ns / 1ps
// Nicholas Palmer | Feb 13, 2023

module pc (
    input logic clk,
    input logic rst,
    input logic pc_halt,
    input logic [63:0] pc_prime,
    output logic [63:0] pc
);
    always_ff @(posedge clk) begin
        if (!rst) pc <= 64'b0;
        else if (pc_halt) pc <= pc_prime;
        else pc <= pc;
    end
    
endmodule