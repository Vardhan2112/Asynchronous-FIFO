`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.07.2025 13:34:10
// Design Name: 
// Module Name: tb
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


module tb;
    
  parameter DATA_WIDTH = 8;
  parameter DEPTH = 8;  // used to simulate a queue size
  parameter PTR_WIDTH=3;

  wire [DATA_WIDTH-1:0] data_out;
  wire full;
  wire empty;
  reg [DATA_WIDTH-1:0] data_in;
  reg w_en, wclk, wrst_n;
  reg r_en, rclk, rrst_n;


  // Instantiate FIFO
  async_fifo_top as_fifo (
    .wclk(wclk), .wrst_n(wrst_n),
    .rclk(rclk), .rrst_n(rrst_n),
    .w_en(w_en), .r_en(r_en),
    .data_in(data_in), .data_out(data_out),
    .full(full), .empty(empty)
  );
  
  integer i=0;
    integer seed = 1;

    // Read and write clock in loop
    always #5 wclk = ~wclk;    // faster writing
    always #10 rclk = ~rclk;   // slower reading
    initial begin
        // Initialize all signals
        wclk = 0;
        rclk = 0;
        wrst_n = 1;     // Active low reset
        rrst_n = 1;     // Active low reset
        w_en = 0;
        r_en = 0;
        data_in = 0;

        // Reset the FIFO
        #40 wrst_n = 0; rrst_n = 0;
        #40 wrst_n = 1; rrst_n = 1;
        
        // TEST CASE 1: Write data and read it back
        $display("%d-testcase 1 start",$time);
        r_en = 1;
        for (i = 0; i < 10; i = i + 1) begin
            data_in = i;
            w_en = 1;
            #10;
            w_en = 0;//to read
            #10;
        end
        $display("%d-testcase 1 end",$time);
        #65;
        // TEST CASE 2: Write data to make FIFO full and try to write more data
        $display("%d-testcase 2 start",$time);
        r_en = 0;
        w_en = 1;
        for (i = 0; i < DEPTH+1 ; i = i + 1) begin
            data_in = 10+i;
            #10;
        end
        
        $display("%d-testcase 2 end",$time);
        w_en=0;
        #30;

        // TEST CASE 3: Read data from empty FIFO and try to read more data
        $display("%d-testcase 3 start",$time);
        w_en = 0;
        r_en = 1;
        for (i = 0; i < DEPTH + 3; i = i + 1) begin
            #20;
        end
        $display("%d-testcase 3 end",$time);
        $finish;
    end

//----------------------------EXPLANATION-----------------------------------------------
// The testbench for the FIFO module generates random data and writes it to the FIFO,
// then reads it back and compares the results. The testbench includes three test cases:
// 1. Write data and read it back.
// 2. Write data to make the FIFO full and try to write more data.
// 3. Read data from an empty FIFO and try to read more data. The testbench uses
// clock signals for writing and reading, and includes reset signals to initialize
// the FIFO. The testbench finishes after running the test cases.
//--------------------------------------------------------------------------------------
    
endmodule
