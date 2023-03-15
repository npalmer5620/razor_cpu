`timescale 1ns / 1ps
// Nicholas Palmer | Feb 13, 2023

module core (
    input logic clk,
    input logic rst
);
    // Control Signals
    logic pc_sel_CONTROL, pc_disable_CONTROL; // PC src select and PC disable control

    logic alu_src_rs1_CONTROL, alu_src_rs2_CONTROL; // ALU src select
    logic [3:0] alu_CONTROL;

    logic dmem_we_CONTROL; // Dmem write enable control

    logic [1:0] wb_CONTROL; // Regfile writeback select control
    logic wbe_CONTROL; // Regfile writeback_enable
    
    // Data Singals
    logic [31:0] pc, jmp_addr;
    logic [31:0] inst, imm;
    logic [31:0] rs1_out, rs2_out, rd_in;
    logic [31:0] alu_out;
    logic [31:0] dmem_rd_data;
    

    // Component Modules
    control_unit CONTROL_UNIT(clk, rst, inst[6:0], pc_sel_CONTROL, alu_src_rs1_CONTROL, alu_src_rs2_CONTROL, dmem_we_CONTROL, wb_CONTROL, wbe_CONTROL, pc_disable_CONTROL);
    
    pc PC(clk, rst, !pc_disable_CONTROL, (pc_sel_CONTROL ? jmp_addr : (pc+4)), pc);

    async_rom ROM({pc[11:2]}, inst);

    regfile REGFILE(clk, rst, wbe_CONTROL,
                    inst[19:15], rs1_out,
                    inst[24:20], rs2_out,
                    inst[11:7], rd_in);
    // Writeback src control
    always_comb begin
        case(wb_CONTROL)
            2'b00: rd_in = alu_out;
            2'b01: rd_in = pc + 4;
            2'b10: rd_in = dmem_rd_data;
            2'b11: rd_in = imm;
            default rd_in = alu_out;
        endcase
    end
    
    // Immediate Generation
    imm_gen IMM_GEN(inst, imm);
    
    alu_decoder ALU_DECODER(inst[6:0], inst[14:12], inst[31:25], alu_CONTROL);
    alu ALU(alu_CONTROL[2:0], alu_CONTROL[3:2], (alu_src_rs1_CONTROL ? pc : rs1_out), (alu_src_rs2_CONTROL ? imm : rs2_out), alu_out);
    
    branch BRANCH(rs1_out, rs2_out, pc, imm, inst[6:0], inst[14:12], jmp_addr);

    sync_ram SYNC_RAM(clk, dmem_we_CONTROL,
                      inst[14:12], alu_out, rs2_out,
                      inst[14:12], alu_out, dmem_rd_data);


endmodule