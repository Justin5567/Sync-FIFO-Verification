import uvm_pkg::*;
`include "uvm_macros.svh"

class fifo_coverage extends uvm_subscriber #(fifo_transaction);
    `uvm_component_utils(fifo_coverage)

    fifo_transaction tr;

    covergroup fifo_cg;
        option.per_instance = 1;

        // Cover Write Enable
        cp_wr_en: coverpoint tr.wr_en {
            bins low = {0};
            bins high = {1};
        }

        // Cover Read Enable
        cp_rd_en: coverpoint tr.rd_en {
            bins low = {0};
            bins high = {1};
        }

        // Cover Data In (Interest ranges)
        cp_data_in: coverpoint tr.data_in {
            bins zeros = {'h0000_0000};
            bins ones = {'hFFFF_FFFF};
            bins low_range = {[1:100]};
            bins misc = default;
        }
        
        // Cover Full flag
        cp_full: coverpoint tr.full {
            bins not_full = {0};
            bins full = {1};
        }

        // Cover Empty flag
        cp_empty: coverpoint tr.empty {
            bins not_empty = {0};
            bins empty = {1};
        }

        // Cross Coverage
        cross_wr_rd: cross cp_wr_en, cp_rd_en;
        cross_full_wr: cross cp_full, cp_wr_en;
        cross_empty_rd: cross cp_empty, cp_rd_en;

    endgroup

    function new(string name, uvm_component parent);
        super.new(name, parent);
        fifo_cg = new();
    endfunction

    virtual function void write(fifo_transaction t);
        tr = t;
        fifo_cg.sample();
    endfunction

endclass