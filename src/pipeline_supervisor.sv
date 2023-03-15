`timescale 1ns / 1ps
// Nicholas Palmer | March 10th, 2023

module pipeline_supervisor(
    input logic clk,
    input logic rst
);
    logic [63:0] pc [0:5];
    logic [31:0] inst;
    
    // Fetch
    logic fetch_complete;
    pc FETCH_PC(clk, rst, pc_halt, (pc_src ? jmp_addr : (pc[0]+4)), pc[0]);
    fetch fetch_unit(clk, rst, pc[0], fetch_complete, inst);
    
    // Decode
    logic [9:0] c_bus;
    logic [4:0] rs1, rs2, rd [0:5];
    logic [63:0] rs1, rs2;
    pc DECODE_PC(clk, rst, pc_halt, pc[0], pc[1]);
    decoder decoder(clk, rst, inst, rs1_id, rs2_id, rd_id, c_bus);
    regfile REGFILE(clk, rst, wb_en, rs1_id, rs1, rs2_id, rs2, inst[11:7], rd_in);
    
    // Execute
    pc EXECUTE_PC(clk, rst, pc_halt, pc[1], pc[2]);
    alu alu_v2(.func(alu_func), .op_a(), .op_b(), .op_out());
    
    // Mem_0
    pc MEM_0_PC(clk, rst, pc_halt, pc[2], pc[3]);
    
    // Mem_1
    pc MEM_1_PC(clk, rst, pc_halt, pc[3], pc[4]);
    
    // Writeback
    pc WRITEBACK_PC(clk, rst, pc_halt, pc[4], pc[5]);
    
endmodule
