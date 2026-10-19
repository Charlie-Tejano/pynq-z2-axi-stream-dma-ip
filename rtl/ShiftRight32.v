`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2026 12:59:04 PM
// Design Name: 
// Module Name: ShiftRight32
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


module ShiftRight32(
    input wire [31:0] din,
    output wire [31:0] dout
    );
    assign dout = din >> 1;
endmodule
