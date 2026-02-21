`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.08.2025 17:01:15
// Design Name: 
// Module Name: fifo_mem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//
// Dependencies: 
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// -----------------------------------------------------------------------
// This module represents the memory for the FIFO. It handles data storage
// and read/write operations. The memory array stores the data, and it is
// updated based on the write enable and full conditions.
// -----------------------------------------------------------------------

module fifo_mem
#(parameter DATA_SIZE = 8,
    parameter ADDR_SIZE = 4)(
    output [DATA_SIZE-1:0] rdata,        // Output data - data to be read
    input [DATA_SIZE-1:0] wdata,         // Input data - data to be written
    input [ADDR_SIZE-1:0] waddr, raddr,  // Write and read address
    input wclk_en, wfull, wclk          // Write clock enable, write full, write clock
    );

    localparam DEPTH = 1<<ADDR_SIZE;     // Depth of the FIFO memory
    reg [DATA_SIZE-1:0] mem [0:DEPTH-1];// Memory array

    assign rdata = mem[raddr];          // Read data

    always @(posedge wclk)
        if (wclk_en && !wfull) mem[waddr] <= wdata; // Write data

endmodule
