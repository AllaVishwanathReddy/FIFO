`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.08.2025 20:54:21
// Design Name: 
// Module Name: sync_fifo
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

// ---------------------------EXPLANATION---------------------------------
// This module implements a synchronous FIFO with configurable depth and
// data width. It uses read/write pointers to manage data flow and checks
// for empty/full conditions. A memory buffer is included for data storage.
// -----------------------------------------------------------------------

module sync_fifo 
//parameters declaration fifo depth is 8bits and the data length is 32 bits.
#(parameter FIFO_DEPTH = 8, 
parameter DATA_WIDTH = 32)
(
input clk,
input rst_n,
input cs, //cs-> chip select
input wr_en,
input rd_en,
input [DATA_WIDTH-1:0] data_in, // Instead of [31:0] [DATA_WIDTH-1:0] is used for 
//future changes if required in the DATA_WIDTH.
output reg [DATA_WIDTH-1:0] data_out, // data_out is stored.
output empty,
output full
);

localparam FIFO_DEPTH_LOG = $clog2(FIFO_DEPTH);
//fifo depth log = 3 (no of bits required to represent 8)

//bidimensional array to declare the data (memory buffer) (32x8) 
reg [DATA_WIDTH-1:0]fifo[0:FIFO_DEPTH-1];

//read and write pointer with 1 extra bit to differentiate empty and full conditions
//here 4 bits.
reg [FIFO_DEPTH_LOG:0]rd_ptr;
reg [FIFO_DEPTH_LOG:0]wr_ptr;

//write
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) // active low 
        wr_ptr <= 0;
    else if(cs && wr_en && !full)begin
        fifo[wr_ptr[FIFO_DEPTH_LOG-1:0]] <= data_in;
        wr_ptr <= wr_ptr+1;
    end
end

//read
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) // active low 
        rd_ptr <= 0;
    else if(cs && rd_en && !empty)begin
        data_out <= fifo[rd_ptr[FIFO_DEPTH_LOG-1:0]];
        rd_ptr <= rd_ptr+1;
    end
end

//empty and full conditions 
assign empty = (rd_ptr == wr_ptr);
assign full = (rd_ptr == {~wr_ptr[FIFO_DEPTH_LOG],wr_ptr[FIFO_DEPTH_LOG-1:0]});


endmodule
