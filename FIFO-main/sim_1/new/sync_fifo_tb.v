`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.08.2025 19:09:49
// Design Name: 
// Module Name: sync_fifo_tb
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

//----------------------------EXPLANATION-----------------------------------------------
// The testbench for the synchronous FIFO module generates clock signals and applies
// various test scenarios to validate the FIFO's functionality. It includes three scenarios:
// 1. Write data and read it back.
// 2. Write and read data alternately in each clock cycle.
// 3. Write the entire FIFO and then read all the data back.
// The testbench uses tasks to simplify the write and read operations and displays the
// results for verification.
//--------------------------------------------------------------------------------------

module sync_fifo_tb();
parameter FIFO_DEPTH = 8; 
parameter DATA_WIDTH = 32;

reg clk = 0;
reg rst_n;
reg cs; //cs-> chip select
reg wr_en;
reg rd_en;
reg [DATA_WIDTH-1:0] data_in;
wire [DATA_WIDTH-1:0] data_out; 
wire empty;
wire full;

integer i;

sync_fifo 
#(.FIFO_DEPTH(FIFO_DEPTH), .DATA_WIDTH(DATA_WIDTH))
dut
(.clk (clk),          
 .rst_n(rst_n),
 .cs(cs),
 .wr_en(wr_en),
 .rd_en(rd_en),
 .data_in(data_in),
 .data_out(data_out),
 .empty(empty),
 .full(full)
);

//create the clk signal
always begin
    #5
    clk = ~clk;
end

task wr_data(input [DATA_WIDTH-1:0]d_in);
begin
    @(posedge clk) // sync to posedge of clk
    cs = 1;
    wr_en =1;
    data_in = d_in;
    $display($time , " wr_data data_in = %0d", data_in);
    @(posedge clk);
    cs = 1; wr_en = 0;
    end
endtask

task rd_data();
begin
    @(posedge clk) // sync to posedge of clk
    cs = 1;
    rd_en =1;
    $display($time , " rd_data data_out = %0d", data_out);
    @(posedge clk);
    cs = 1; rd_en = 1;
    end
endtask

//create stimulus 
initial begin
    #10
    rst_n =0;
    rd_en = 0; 
    wr_en= 0;
    @(posedge clk)
    rst_n =1;
    $display($time, "\n Scenario 1");
    wr_data(1);     //writing 3 data inputs into the fifo
    wr_data(10);
    wr_data(100);   
    
    rd_data();      //reading those 3 inputs
    rd_data();
    rd_data();      
    
    $display($time, "\n Scenario 2");
    //write first and read in the next clock cycle
    for(i=0;i<FIFO_DEPTH; i= i+1)begin
        wr_data(2**i);
        rd_data();
    end
    
    $display($time, "\n Scenario 3");
    // write the complete data and then read 
    for(i=0;i<=FIFO_DEPTH; i= i+1)begin
        wr_data(2**i);
    end
    
    for(i=0;i<FIFO_DEPTH; i= i+1)begin
        rd_data();
    end
    
    #50 
    $finish;
end
endmodule

