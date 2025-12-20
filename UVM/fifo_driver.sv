import uvm_pkg::*;
`include "uvm_macros.svh"

class fifo_driver extends uvm_driver #(fifo_transaction);
    `uvm_component_utils(fifo_driver)

    virtual fifo_if vif;
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
            `uvm_fatal("DRV", "not able to get interface")    
    endfunction

    virtual task run_phase(uvm_phase phase);
        vif.drv_cb.wr_en    <= 0;
        vif.drv_cb.rd_en    <= 0;
        vif.drv_cb.cs       <= 0;

        forever begin
            seq_item_port.get_next_item(req);
            driver_item(req);
            seq_item_port.item_done();    
        end

    endtask

    task driver_item(fifo_transaction tr);
        @(vif.drv_cb);
        vif.drv_cb.cs   <= 1;
        vif.drv_cb.wr_en <= tr.wr_en;
        vif.drv_cb.rd_en <= tr.rd_en;
        if(tr.wr_en) vif.drv_cb.data_in <= tr.data_in;
    endtask


endclass