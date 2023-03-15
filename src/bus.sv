// Nicholas Palmer | Feb 13, 2023
interface MemoryBus;
    logic clk; // bus clock
    logic rst; // global reset
    logic wr_en; // write data to address
    logic rd_en; // read data from address
    logic [31:0] wr_addr; // 32 bit write address
    logic [31:0] wr_data; // 32 bit write data
    logic [31:0] rd_addr; // 32 bit read address
    logic [31:0] rd_data; // 32 bit read data
endinterface //MemoryBus