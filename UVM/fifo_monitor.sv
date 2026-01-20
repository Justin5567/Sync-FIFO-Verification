import uvm_pkg::*;
`include "uvm_macros.svh"

class fifo_monitor extends uvm_monitor;
    `uvm_component_utils(fifo_monitor)

    virtual fifo_if vif;
    uvm_analysis_port #(fifo_transaction) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
            `uvm_fatal("Monitor", "Can not access interface")
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            fifo_transaction tr;
            tr = fifo_transaction::type_id::create("tr");

            @(vif.mon_cb);
            if(vif.mon_cb.cs) begin
                tr.wr_en = vif.mon_cb.wr_en;
                tr.rd_en = vif.mon_cb.rd_en;
                tr.data_in = vif.mon_cb.data_in;

                tr.data_out = vif.mon_cb.data_out;
                tr.full     = vif.mon_cb.full;
                tr.empty    = vif.mon_cb.empty;
                ap.write(tr);
            end
        end
    endtask

endclass