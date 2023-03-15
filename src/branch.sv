`timescale 1ns / 1ps
// Nicholas Palmer | Feb 17, 2023

module branch (
    input logic [31:0] rs1,
    input logic [31:0] rs2,
    input logic [31:0] pc,
    input logic [31:0] imm,
    input logic [6:0] opcode,
    input logic [2:0] funct3,
    output logic [31:0] jmp_addr);
    
    always_comb begin
        case (opcode)
            // B Type (Branch
            7'b1100011: begin
                case (funct3) 
                    3'b000 : if (rs1 == rs2) jmp_addr = pc + imm; else jmp_addr = pc + 4;  // BEQ
                    3'b001 : if (rs1 != rs2) jmp_addr = pc + imm; else jmp_addr = pc + 4; // BNE
                    // 3'b010 : ; // Do Nothing
                    // 3'b011 : ; // Do Nothing
                    3'b100 : if ($signed(rs1) < $signed(rs2)) jmp_addr = pc + imm; else jmp_addr = pc + 4; // BLT
                    3'b101 : if ($signed(rs1) >= $signed(rs2)) jmp_addr = pc + imm; else jmp_addr = pc + 4; // BGE
                    3'b110 : if ($unsigned(rs1) < $unsigned(rs2)) jmp_addr = pc + imm; else jmp_addr = pc + 4; // BLTU !! DOUBLE CHECK THESE
                    3'b111 : if ($unsigned(rs1) >= $unsigned(rs2)) jmp_addr = pc + imm; else jmp_addr = pc + 4; // BGEU !! DOUBLE CHECK THESE
                    default: jmp_addr = pc + 4; // Do Nothing
                endcase
            end
            // J Type Jump (JAL)
            7'b1101111: begin
                jmp_addr = pc + imm;
            end
            // J Type Jump (JALR)
            7'b1100111: begin
                jmp_addr = rs1 + imm;
            end
            default: jmp_addr = 32'bx;
        endcase    
    end
endmodule
