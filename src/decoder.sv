`timescale 1ns / 1ps
// Nicholas Palmer | March 12, 2023

module decoder(
    input logic clk,
    input logic rst,
    input logic [31:0] inst,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [4:0] rd,
    output logic [9:0] c_bus
    );
    always_comb begin
        rs1 = inst[19:15];
        rs2 = inst[24:20];
        rd = inst[11:7];
    end
    
    always_ff @(posedge clk) begin
        // Program counter source
        c_bus[0] <= (opcode inside {OP_JAL, OP_JALR, OP_BRANCH});
        // Write to data memory
        c_bus[1] <= (opcode inside {OP_STORE});
        // ALU input 1 either PC or rs1
        c_bus[2] <= (opcode inside {OP_AUIPC, OP_JAL, OP_JALR});
        // ALU input 2 either imm or rs2
        c_bus[3] <= (opcode inside {OP_ARITH_IMM, OP_AUIPC, OP_LOAD, OP_STORE});
        // write back enable control
        c_bus[4] <= (opcode inside {OP_LUI, OP_ARITH, OP_ARITH_IMM, OP_LOAD, OP_JAL, OP_JALR, OP_AUIPC}) && !pc_disable_CONTROL; // ALU, ALUi, LW, JAL, JALR
        
        // Writeback src
        case (opcode)
            OP_AUIPC, OP_ARITH, OP_ARITH_IMM: c_bus[5] <= 2'b00; // ALUout
            OP_JAL, OP_JALR: c_bus[5] <= 2'b01; // pc+4
            OP_LOAD: c_bus[5] <= 2'b10; // dmem
            OP_LUI: c_bus[5] <= 2'b11; // imm
            default: c_bus[5] <= 2'b00; // ALUout
        endcase
    end
endmodule
