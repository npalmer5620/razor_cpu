`timescale 1ns / 1ps
// Nicholas Palmer | Feb 17, 2023

module control_unit (
    input clk,
    input rst,
    input logic [6:0] opcode,
    output logic pc_sel_CONTROL, // PC src select

    output logic alu_src_rs1_CONTROL, alu_src_rs2_CONTROL, // ALU src select

    output logic dmem_we_CONTROL, // Dmem write enable control

    output logic [1:0] wb_CONTROL, // Regfile writeback select control
    output logic wbe_CONTROL, // Regfile writeback_enable
    output logic pc_disable_CONTROL
);
    /*
    enum [6:0] {
            LUI=7'b0110111, JAL=7'b1101111, JALR=7'b1100111,
            BRANCH=7'b1100011, LOAD=7'b0000011, STORE=7'b0100011,
            ARITH_IMM=7'b0010011, ARITH=7'b0110011, FENCE=7'b0001111,
            SYSTEM=7'b1110011, AUIPC=7'b0010111
          } i_type;
    */
    logic [2:0] inst_cnt;
    
    // Instruction cycle counter
    always_ff @(posedge clk) begin
        if (!rst) begin
            inst_cnt <= 3'b000;
        end else begin
            // LOAD
            if (opcode inside {7'b0000011}) begin
                if (inst_cnt == 3'b001) begin
                    inst_cnt <= 3'b000;
                end else begin
                    inst_cnt <= inst_cnt + 1;
                end
            end
        end
    end
    
    // PC Disable logic based on counter
    always_comb begin
        if (opcode inside {7'b0000011} && (inst_cnt != 3'b001)) begin
            pc_disable_CONTROL = 1;
        end else begin
            pc_disable_CONTROL = 0;
        end
    end
    
    
    // pc_sel_CONTROL
    always_comb begin
        // JAL, JALR, BRANCH
        pc_sel_CONTROL = (opcode inside {OP_JAL, OP_JALR, OP_BRANCH});
    end
    
    // Write to data memory
    always_comb begin
        // STORE
        dmem_we_CONTROL = (opcode inside {7'b0100011});
    end
    
    // ALU input 1 either PC or rs1
    always_comb begin
        // AUIPC, JAL, JALR
        alu_src_rs1_CONTROL = (opcode inside {7'b0010111, 7'b1101111, 7'b1100111});
    end
    
    // ALU input 2 either imm or rs2
    always_comb begin
        // ARITH_IMM, AUIPC, LOAD, STORE
        alu_src_rs2_CONTROL = (opcode inside {7'b0010011, 7'b0010111, 7'b0000011, 7'b0100011});
    end
    
    // write back enable control
    always_comb begin
        wbe_CONTROL = (opcode inside {7'b0110111, 7'b0110011, 7'b0010011, 7'b0000011, 7'b1101111, 7'b1100111, 7'b0010111}) && !pc_disable_CONTROL; // ALU, ALUi, LW, JAL, JALR
    end
    
    // Writeback source
    always_comb begin
        case (opcode)
            7'b0010111, 7'b0110011, 7'b0010011: wb_CONTROL = 2'b00; // ALUout
            7'b1101111, 7'b1100111: wb_CONTROL = 2'b01; // pc+4
            7'b0000011: wb_CONTROL = 2'b10; // dmem
            7'b0110111: wb_CONTROL = 2'b11; // imm
            default: wb_CONTROL = 2'b00; // ALUout
        endcase
    end
    
endmodule