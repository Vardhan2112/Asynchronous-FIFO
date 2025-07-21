`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.07.2025 13:21:40
// Design Name: 
// Module Name: async_fifo_top
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


module async_fifo_top #(parameter DEPTH=8, DATA_WIDTH=8,PTR_WIDTH=3) (
    input wclk,wrst_n,rclk,rrst_n,w_en,r_en,
    input [DATA_WIDTH-1:0] data_in,
    output [DATA_WIDTH-1:0] data_out,//concurrent assignment 
    output full,empty//regs in there
    );
    
    wire [PTR_WIDTH:0] g_wptr,b_wptr;//concurrent assignments
    wire [PTR_WIDTH:0] g_rptr,b_rptr;
    wire [PTR_WIDTH:0] g_wptr_sync,g_rptr_sync;//only grays concurrent
    
    wire [PTR_WIDTH-1:0] waddr,raddr;
    
    sync_2ff #(PTR_WIDTH) rffs(rclk,rrst_n,g_wptr,g_wptr_sync);//read side
    sync_2ff #(PTR_WIDTH) wffs(wclk,wrst_n,g_rptr,g_rptr_sync);//read side
    
    wptr_handler #(PTR_WIDTH) wptr_h(wclk,wrst_n,w_en,g_rptr_sync,b_wptr,g_wptr,full);
    rptr_handler #(PTR_WIDTH) rptr_h(rclk,rrst_n,r_en,g_wptr_sync,b_rptr,g_rptr,empty);
    
    assign waddr=b_wptr[PTR_WIDTH-1:0];
    assign raddr=b_rptr[PTR_WIDTH-1:0];
    
    fifo_mem fifom(wclk,rclk,w_en,r_en,waddr,raddr,data_in,full,empty,data_out);
     
endmodule
