`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.08.2025 16:54:02
// Design Name: 
// Module Name: synchronizer
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
// This module is a 2-flop synchronizer used for transferring signals
// between clock domains. It ensures data stability during clock domain
// transitions.
// -----------------------------------------------------------------------

//2-flop synchronizer
module synchronizer
#(parameter SIZE = 4)( 
    output reg [SIZE-1:0] q2,   // Output of the second flip-flop
    input [SIZE-1:0] din,       // Input data
    input clk, rst_n            // Clock and reset
    );

    reg [SIZE-1:0] q1; // Output of the first flip-flop

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            {q2, q1} <= 0;          // Reset the FIFO
        else 
            {q2, q1} <= {q1, din};  // Shift the data
    end 

endmodule