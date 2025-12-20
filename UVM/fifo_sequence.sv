import uvm_pkg::*;
`include "uvm_macros.svh"

class fifo_random_sequence extends uvm_sequence #(fifo_transaction);
    `uvm_object_utils(fifo_random_sequence)

    function new(string name = "fifo_random_sequence");
        super.new(name);
    endfunction

    virtual task body();
        repeat(50) begin
            req = fifo_transaction::type_id::create("req");
            start_item(req);
            if (!req.randomize() with {wr_en != rd_en;}) begin
                `uvm_error("SEQ", "Random fail")
            end
            finish_item(req);
        end
    endtask
endclass