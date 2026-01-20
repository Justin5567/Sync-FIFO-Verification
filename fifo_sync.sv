module fifo_sync 
    #(parameter int FIFO_DEPTH = 8,
      parameter int FIFO_WIDTH = 32)

(
input clk,
input rst_n,
input cs,
input wr_en,
input rd_en,
input [FIFO_WIDTH-1:0] data_in,
output logic [FIFO_WIDTH-1:0] data_out,
output empty,
output full
);

localparam FIFO_DEPTH_LOG = $clog2(FIFO_DEPTH);

reg [FIFO_WIDTH-1:0] fifo [0:FIFO_DEPTH-1];
reg [FIFO_DEPTH_LOG:0] write_ptr;
reg [FIFO_DEPTH_LOG:0] read_ptr;



integer i;
// fifo
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        for(i=0;i<FIFO_DEPTH;i=i+1)begin
            fifo[i]<=0;
        end
    end
    else if(cs && wr_en && !full)
        fifo[write_ptr[FIFO_DEPTH_LOG-1:0]] <= data_in;
end

always@(*)begin
    data_out = fifo[read_ptr[FIFO_DEPTH_LOG-1:0]];
end

// write
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        write_ptr<=0;
    end
    else if(cs && wr_en && !full)
        write_ptr<=write_ptr+1;
end

// read
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        read_ptr<=0;
    else if(cs && rd_en && !empty)
        read_ptr<=read_ptr+1;
end

// empty
assign empty = read_ptr == write_ptr;

// full
assign full = read_ptr == {~write_ptr[FIFO_DEPTH_LOG], write_ptr[FIFO_DEPTH_LOG-1:0]};



endmodule