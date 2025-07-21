`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.07.2025 11:26:45
// Design Name: 
// Module Name: sync_2ff
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


module sync_2ff#(parameter PTR_WIDTH=3)(
    input clk,
    input rst,
    input [PTR_WIDTH:0] din,
    output reg [PTR_WIDTH:0] dout
    );
    
    reg [PTR_WIDTH:0] q1;
    
    always@(posedge clk) begin
        if(!rst) begin
            q1<=0;
            dout<=0;
        end
        else begin
            q1<=din;
            dout<=q1;
        end
    end
endmodule
