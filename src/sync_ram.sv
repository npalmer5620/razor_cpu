`timescale 1ns / 1ps
// Nicholas Palmer | Feb 17, 2023

module sync_ram (
    input logic clk, // bus clock
    input logic we_CONTROL, // write enable data to address
    input logic [2:0] wr_CONTROL, // Write/Store Control
    input logic [31:0] wr_addr, // 32 bit write address
    input logic [31:0] wr_data, // 32 bit write data
    input logic [2:0] rd_CONTROL, // Read/Load Control
    input logic [31:0] rd_addr, // 32 bit read address
    output logic [31:0] rd_data // 32 bit read data
);
    // logic [7:0] mem0 [0:1023]; // 1kb BRAM x 4 (hopefully)
    // logic [7:0] mem1 [0:1023];
    // logic [7:0] mem2 [0:1023];
    // logic [7:0] mem3 [0:1023];
    logic [7:0] mem [0:4095]; // 12-bit address space
    
    

    // Write/Store instructions
    always_ff @(posedge clk) begin
        if (we_CONTROL) begin
            case (wr_CONTROL)
                3'b000 : mem[wr_addr] <= wr_data[7:0]; // Byte
                3'b001 : {mem[wr_addr+1], mem[wr_addr]} <= wr_data[15:0]; // Half Word
                3'b010 : {mem[wr_addr+3], mem[wr_addr+2], mem[wr_addr+1], mem[wr_addr]} <= wr_data; // Word
                default: {mem[wr_addr+3], mem[wr_addr+2], mem[wr_addr+1], mem[wr_addr]} <= wr_data; // default
            endcase
        end
    end

    // Read/Load
    always_ff @(posedge clk) begin
        case (rd_CONTROL)
            3'b000 : rd_data <= {{24{mem[rd_addr][7]}}, mem[rd_addr]}; // Byte
            3'b001 : rd_data <= {{16{mem[rd_addr+1][7]}}, mem[rd_addr+1], mem[rd_addr]}; // Half Word
            3'b010 : rd_data <= {mem[(rd_addr+3)], mem[(rd_addr+2)], mem[(rd_addr+1)], mem[rd_addr]}; // Word
            3'b100 : rd_data <= {{24'b0}, mem[rd_addr]}; // Unsigned Byte
            3'b101 : rd_data <= {{16'b0}, mem[rd_addr+1], mem[rd_addr]}; // Unsigned Half
            default: rd_data <= {mem[(rd_addr+3)], mem[(rd_addr+2)], mem[(rd_addr+1)], mem[rd_addr]}; // Word default
        endcase
    end
endmodule