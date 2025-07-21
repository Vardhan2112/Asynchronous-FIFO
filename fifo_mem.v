`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.07.2025 13:07:35
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


module fifo_mem#(PTR_WIDTH=3,DEPTH=8,DATA_WIDTH=8)(
    input wclk,rclk,w_en,r_en,
    input [PTR_WIDTH-1:0] waddr,raddr,
    input [DATA_WIDTH-1:0] data_in,
    input full,empty,
    output [DATA_WIDTH-1:0] data_out
    );
    
    reg [DATA_WIDTH-1:0] fifo[0:DEPTH-1];
    
    always@(posedge wclk) begin
        if(w_en & !full) begin
            fifo[waddr]<=data_in;
        end
    end
    
    /*
    always@(posedge rclk) begin
        if(r_en & !empty) begin
            data_out<=fifo[raddr];
        end
    end
    */
    
    assign data_out=fifo[raddr];
    
endmodule
