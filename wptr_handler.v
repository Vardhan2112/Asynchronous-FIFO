`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.07.2025 12:44:08
// Design Name: 
// Module Name: wptr_handler
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


module wptr_handler#(parameter PTR_WIDTH=3)(
    input wclk,wrst_n,w_en,
    input [PTR_WIDTH:0] g_rptr_sync,
    output reg [PTR_WIDTH:0] b_wptr,g_wptr,
    output reg full 
    );
    
    wire [PTR_WIDTH:0] b_wptr_next,g_wptr_next;//just to be sure that sync value takes 2 cycles so
    
    reg wrap_around;
    wire wfull;
    
    assign b_wptr_next=b_wptr+(w_en & !full);//only if w_en is on this is correct way
    assign g_wptr_next=(b_wptr_next>>1)^b_wptr_next;
    
    always@(posedge wclk or negedge wrst_n) begin
        if(!wrst_n) begin
            b_wptr<=0;
            g_wptr<=0;
        end
        
        else begin
            b_wptr<=b_wptr_next;
            g_wptr<=g_wptr_next;//cause we have already updated using w_en
        end
    end
    
    always@(posedge wclk or negedge wrst_n) begin
        if(!wrst_n) begin
            full<=0;
        end
        
        else full<=wfull;
    end
    
    assign wfull=(g_wptr_next==({~(g_rptr_sync[PTR_WIDTH:PTR_WIDTH-1]),g_rptr_sync[PTR_WIDTH-2:0]}));
    //------------------------------------------------------------------
    // Simplified version of the three necessary full-tests:
    // assign wfull_val=((wg_next[ADDR_SIZE] !=wq2_rptr[ADDR_SIZE] ) &&
    // (wg_next[ADDR_SIZE-1] !=wq2_rptr[ADDR_SIZE-1]) &&
    // (wg_next[ADDR_SIZE-2:0]==wq2_rptr[ADDR_SIZE-2:0]));
    //------------------------------------------------------------------
    //checking one step ahead just in case if wen is on
    
endmodule
