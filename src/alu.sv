`timescale 1ns / 1ps
// Nicholas Palmer | Feb 13, 2023

module alu
(
    // ALU Control Signals
    input logic [2:0] funct3_CONTROL, // fund. operation
    input logic funct7_bit_CONTROL, // REGULAR or ALT operation

    // I/O logic
    input logic [31:0] op_a,
    input logic [31:0] op_b,
    output logic [31:0] op_out
);

always_comb begin
    case (funct3_CONTROL)
        3'b000: begin // SUB, ADD, ADDI
                    case (funct7_bit_CONTROL)
                        1'b0: op_out = (op_a + op_b);
                        1'b1: op_out = (op_a - op_b);
                        default: op_out = 32'b0;
                    endcase
                end
        3'b001: op_out = op_a << op_b[4:0]; // SLL, SLLI
        
        3'b010: op_out = ($signed(op_a) < $signed(op_b)) ? 32'b1 : 32'b0; // SLT, SLTI
        3'b011: op_out = (op_a < op_b) ? 32'b1 : 32'b0; // SLTU, SLTIU
        
        3'b100: op_out = op_a ^ op_b; // XOR, XORI
        
        3'b101: begin // SRA, SRAI, SRL, SRLI
                    case (funct7_bit_CONTROL)
                        1'b0: op_out = op_a >> op_b[4:0];
                        1'b1: op_out = $signed(op_a) >>> op_b[4:0];
                        default: op_out = 32'b0;
                    endcase
                end
        3'b110: op_out = op_a | op_b; // OR, ORI
        3'b111: op_out = op_a & op_b; // AND, ANDI
        default: op_out = 32'b0;
    endcase
end
    
endmodule