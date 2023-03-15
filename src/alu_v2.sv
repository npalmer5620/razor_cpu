`timescale 1ns / 1ps
// Nicholas Palmer | March 12, 2023

module alu_v2(
    input logic [3:0] func,
    
    // I/O logic
    input logic [63:0] op_a,
    input logic [63:0] op_b,
    output logic [63:0] op_out
);
    
    always_comb begin
        casez (func)
            4'b0000: op_out = (op_a + op_b); // ADD, ADDI
            4'b1000: op_out = (op_a - op_b); // SUB

            4'b?001: op_out = op_a << op_b[4:0]; // SLL, SLLI
            
            4'b?010: op_out = ($signed(op_a) < $signed(op_b)) ? 64'b1 : 64'b0; // SLT, SLTI
            4'b?011: op_out = (op_a < op_b) ? 64'b1 : 64'b0; // SLTU, SLTIU
            
            4'b?100: op_out = op_a ^ op_b; // XOR, XORI
            
            4'b0101: op_out = op_a >> op_b[4:0]; // SRL, SRLI
            4'b1101: op_out = $signed(op_a) >>> op_b[4:0]; // SRA, SRAI

            4'b?110: op_out = op_a | op_b; // OR, ORI
            4'b?111: op_out = op_a & op_b; // AND, ANDI
            default: op_out = 64'b0;
        endcase
    end

endmodule
