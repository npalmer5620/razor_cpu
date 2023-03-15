`timescale 1ns / 1ps
// Nicholas Palmer | Feb 13, 2023

module alu_decoder(
    input logic [6:0] opcode,
    input logic [2:0] funct3,
    input logic funct7_bit,
    output logic [3:0] alu_func
    );
    
    // always_comb alu_CONTROL_A = funct3;
    always_comb begin
        case (opcode)
            // Handle AUIPC (rs <= IMM + PC), LOAD & STORE (mem[rs1 + IMM])
            OP_AUIPC, OP_LOAD, OP_STORE : alu_func = 4'b0000; // ADD
            default : alu_func = {funct7_bit, funct3}; // Normal 
        endcase
    end
    
endmodule
