interface fifo_if(input logic clk, input logic rst_n);

logic cs;
logic wr_en;
logic rd_en;
logic [31:0] data_in;
logic [31:0] data_out;
logic empty;
logic full;


// clocking to avoid race condition
clocking drv_cb @(posedge clk);
    default input #1ns output #1ns;
    output cs, wr_en, rd_en, data_in;
    input full, empty;
endclocking


clocking mon_cb @(posedge clk);
    default input #1ns output #1ns;
    input cs, wr_en, rd_en, data_in, data_out, full, empty;
endclocking
endinterface