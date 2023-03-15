`timescale 1ns / 1ps
// Nicholas Palmer | Feb 17, 2023

module imm_gen (
    input logic [31:0] inst,
    output logic [31:0] imm
);
    always_comb begin
        case(inst[6:0])
            7'b1100111, 7'b0000011, 7'b0010011, 7'b0001111, 7'b1110011 : imm = { {21{inst[31]}}, inst[30:20] }; // IMMEDIATE
            7'b0110111, 7'b0010111 : imm = { inst[31:12], 12'b0 }; // UPPER IMMEDIATE
            7'b0100011 : imm = { {21{inst[31]}}, inst[30:25], inst[11:7] }; // STORE
            7'b1100011 : imm = { {20{inst[31]}}, inst[7], inst[31:25], inst[11:8], 1'b0 }; // BRANCH
            7'b1101111 : imm = { {12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0 }; // JUMP
            default imm = 32'bx; // dont care
        endcase
    end
endmodule