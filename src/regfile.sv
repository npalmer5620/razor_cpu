`timescale 1ns / 1ps
// Nicholas Palmer | Feb 13, 2023

module regfile (
    input logic clk,
    input logic rst,
    input logic wbe_CONTROL,

    // Register Source 1
    input logic [4:0] rs1_sel,
    output logic [31:0] rs1_out,

    // Register Source 2
    input logic [4:0] rs2_sel,
    output logic [31:0] rs2_out,

    // Register Dest.
    input logic [4:0] rd_sel,
    input logic [31:0] rd_in
);
    // Define Registers (0 is hardwired 0)
    logic [31:0] r [1:31];

    // Read operations are combinational 
    always_comb begin
        // Assign registers based on select
        rs1_out = (rs1_sel == 5'b0) ? (32'b0) : r[rs1_sel];
        rs2_out = (rs2_sel == 5'b0) ? (32'b0) : r[rs2_sel];
    end

    // Write operations are sequential
    // Make sure we are not trying to assign to hardwire 0!
    always_ff @(posedge clk) begin
        if (!rst) begin
            for (integer i = 1; i < 32; i++) begin
                r[i] <= 32'b0;
            end
        end else if (wbe_CONTROL && (rd_sel != 5'b0)) begin
            r[rd_sel] <= rd_in; 
        end else begin
            r[rd_sel] <= r[rd_sel]; // PERSIST, this may be unnecessary
        end
    end
endmodule