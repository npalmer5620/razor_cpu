`timescale 1ns / 1ps
// Nicholas Palmer | Feb 13, 2023

module async_rom (
    input logic [9:0] a_addr,
    output logic [31:0] a_out
);
    logic [31:0] mem [0:1023]; // 1kb DistRAM memory (hopefully)
    
    initial begin
        $readmemh("rom.mem", mem);
    end

    always_comb begin
        a_out = mem[a_addr];
    end
endmodule