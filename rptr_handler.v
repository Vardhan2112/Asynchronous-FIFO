`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.07.2025 13:00:22
// Design Name: 
// Module Name: rptr_handler
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


module rptr_handler#(parameter PTR_WIDTH=3)(
    input rclk,rrst_n,r_en,
    input [PTR_WIDTH:0] g_wptr_sync,
    output reg [PTR_WIDTH:0] b_rptr,g_rptr,
    output reg empty 
    );
    
    wire [PTR_WIDTH:0] b_rptr_next,g_rptr_next;//just to be sure that sync value takes 2 cycles so
    
    reg wrap_around;
    wire rempty;
    
    assign b_rptr_next=b_rptr+(r_en & !empty);//only if r_en is on this is correct way
    assign g_rptr_next=(b_rptr_next>>1)^b_rptr_next;
    
     assign rempty=(g_rptr_next==g_wptr_sync);
    //checking one step ahead just in case if ren is on
    
    always@(posedge rclk or negedge rrst_n) begin
        if(!rrst_n) begin
            b_rptr<=0;
            g_rptr<=0;
        end
        
        else begin
            b_rptr<=b_rptr_next;
            g_rptr<=g_rptr_next;//cause we have already updated using r_en
        end
    end
    
    always@(posedge rclk or negedge rrst_n) begin
        if(!rrst_n) begin
            empty<=1;//default vlaue
        end
        
        else empty<=rempty;
    end
    
   
    
endmodule

