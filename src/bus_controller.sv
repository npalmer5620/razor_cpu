`timescale 1ns / 1ps

module bus_controller(
    input logic clk_A, clk_B,
    input logic rst_A, rst_B,
    input logic [31:0] addr_A, addr_B, // A port address, B port address
    input logic [3:0] write_mask_A, // Which bytes to write to from address offset and we : {we, [2:0] funct3}
    input logic [31:0] d_write_A, // A port write data
    output logic [31:0] d_read_A, // A port read data
    output logic [31:0] d_read_B,
);
    logic RAM_en_A;
    logic [31:0] RAM_out, ROM_out;
    
    async_rom ROM({addr_A[11:2]}, ROM_out);
    blk_ram RAM(clk_A, RAM_en_A, write_mask_A, (addr_A[11:0]), d_write_A, RAM_out,
                clk_A, 1'b0);
    
    // Peripherial MUX 
    always_comb begin
        // Instruction memory 0x0000_0000 <-> 0x0fff_ffff
        if (addr_A < 32'h10000000) begin
            RAM_en_A = 1'b0;
            d_read_A = ROM_out;
        end
        // SRAM 0x1000_0000 <-> 0x1fff_ffff
        else if ((addr_A >= 32'h10000000) && (addr_A < 32'h20000000)) begin
            RAM_en_A = 1'b1;
            d_read_A = RAM_out;
        end
        else begin
            RAM_en_A = 1'b0;
            d_read_A = 32'bx;
        end
    end
endmodule
