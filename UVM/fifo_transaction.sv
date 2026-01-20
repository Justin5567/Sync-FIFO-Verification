import uvm_pkg::*;
`include "uvm_macros.svh"

class fifo_transaction extends uvm_sequence_item;
    rand bit [31:0] data_in;
    rand bit        wr_en;
    rand bit        rd_en;
    bit      [31:0] data_out;
    bit             full;
    bit             empty;

    `uvm_object_utils_begin(fifo_transaction)
        `uvm_field_int(data_in,  UVM_ALL_ON)
        `uvm_field_int(wr_en,    UVM_ALL_ON)
        `uvm_field_int(rd_en,    UVM_ALL_ON)
        `uvm_field_int(data_out, UVM_ALL_ON)
        `uvm_field_int(full,     UVM_ALL_ON)
        `uvm_field_int(empty,    UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "fifo_transaction");
        super.new(name);
    endfunction

endclass