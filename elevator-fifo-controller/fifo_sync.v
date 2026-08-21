`timescale 1ns / 1ps

module fifo_sync
#(
    parameter fifo_depth = 8,
    parameter data_width = 4
)
(
    input clk,
    input rst,
    input cs,
    input w_enable,
    input r_enable,
    input [data_width-1:0] data_in,
    output reg [data_width-1:0] data_out,
    output reg data_valid,
    output full,
    output empty
);

localparam fifo_depth_log = $clog2(fifo_depth);
    //It is caluclating no.of.bits require for fifo_depth
    //  fifo_depth=8 
    // fifo_depth=2**n where n=no.of.bits
    // log2(fifo_depth)=nlog2(2)
    //log2(fifo_depth)=n
    //here log2() means logarithm with base 2 it represents result in binary.
    //fifo_depth_log is also called as address_width or addr_width.

// POINTERS
reg [fifo_depth_log:0] write_pointer;
reg [fifo_depth_log:0] read_pointer;

// MEMORY
reg [data_width-1:0] fifo [0:fifo_depth-1];

//======================
// WRITE LOGIC
//======================
always @(posedge clk or posedge rst) begin
    if (rst)
        write_pointer <= 0;
    else if (cs && w_enable && !full) begin
        fifo[write_pointer[fifo_depth_log-1:0]] <= data_in;
        write_pointer <= write_pointer + 1;
    end
end

//======================
// READ LOGIC
//======================

always @(posedge clk or posedge rst) begin
    if (rst) begin
        read_pointer <= 0;
        data_out <= 0;
        data_valid <= 0;
    end
    else if (cs && r_enable && !empty) begin
        data_out <= fifo[read_pointer[fifo_depth_log-1:0]];
        read_pointer <= read_pointer + 1;
        data_valid <= 1;   // 1-cycle pulse
    end
    else begin
        data_valid <= 0;
    end
end

//======================
// STATUS FLAGS
//======================
assign empty = (read_pointer == write_pointer);

assign full  = (read_pointer == {~write_pointer[fifo_depth_log],write_pointer[fifo_depth_log-1:0]});

endmodule
