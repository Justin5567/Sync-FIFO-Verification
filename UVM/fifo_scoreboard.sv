import uvm_pkg::*;
`include "uvm_macros.svh"

class fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifo_scoreboard)

    uvm_analysis_imp #(fifo_transaction, fifo_scoreboard) item_got_export;

    bit [31:0] expected_queue[$];
    int matched_count = 0;
    int error_count = 0;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        item_got_export = new("item_got_export", this);
    endfunction

    virtual function void write(fifo_transaction tr);
        if(tr.wr_en) begin
            expected_queue.push_back(tr.data_in);
            `uvm_info("[Scoreboard] Write", $sformatf("Data = %h", tr.data_in), UVM_LOW)
        end

        if(tr.rd_en) begin
            if(expected_queue.size()==0)begin
                `uvm_error("[SCB_RD_ERR]", "Reading from the empty FIFO")
                error_count ++;
            end
            else begin
                bit [31:0] expected_data;
                expected_data = expected_queue.pop_front();

                if(tr.data_out === expected_data)begin
                    `uvm_info("SCB_MATCH", $sformatf("Success! Data = %h", tr.data_out), UVM_LOW)
                    matched_count++;
                end
                else begin
                    `uvm_error("SCB_MISMATCH", $sformatf("Wrong! Golden: %h, Your Answer: %h", expected_data, tr.data_out))
                    error_count++;
                end

            end


        end

    endfunction

    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("SCB_FINAL", $sformatf("測試結束。成功次數: %d, 錯誤次數: %d", matched_count, error_count), UVM_LOW)
    endfunction


endclass
