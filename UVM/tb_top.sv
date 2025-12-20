import uvm_pkg::*;
`include "uvm_macros.svh"
module tb_top;
    logic clk;
    logic rst_n;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst_n = 0;
        #20 rst_n = 1;
    end


    fifo_if inf(clk, rst_n);

    fifo_sync #(
        .FIFO_DEPTH(8),   
        .FIFO_WIDTH(32)   
    ) dut (
        .clk(clk),        
        .rst_n(rst_n),    
        .cs(inf.cs),      
        .wr_en(inf.wr_en),
        .rd_en(inf.rd_en),
        .data_in(inf.data_in),   
        .data_out(inf.data_out), 
        .empty(inf.empty),
        .full(inf.full)   
    );

    initial begin
        uvm_config_db#(virtual fifo_if)::set(null, "*", "vif", inf);
        run_test("fifo_test");
    end
endmodule
