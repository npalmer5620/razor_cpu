`timescale 1ns / 1ps
// Nicholas Palmer | March 12, 2023


module fetch_unit(
    input logic clk,
    input logic rst,
    input logic [63:0] addr,
    output logic [31:0] inst_out,
    output logic fetch_done,
    );
    
    logic [31:0] mem [0:1023]; // 1kb DistRAM memory (hopefully)
    
    initial begin
        $readmemh("rom.mem", mem);
    end

    always_ff @(posedge clk) begin
        if (!rst) begin
            inst_out <= 32'b0;
            fetch_done <= 0;
        end else begin
            inst_out <= mem[addr[9:0]];
            fetch_done <= 1;
        end
    end
endmodule
