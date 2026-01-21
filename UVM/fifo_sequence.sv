import uvm_pkg::*;
`include "uvm_macros.svh"

// --- Base Sequence ---
class fifo_base_sequence extends uvm_sequence #(fifo_transaction);
    `uvm_object_utils(fifo_base_sequence)
    function new(string name = "fifo_base_sequence"); super.new(name); endfunction
endclass

// --- 1. Fill the FIFO until it is full ---
class fifo_fill_sequence extends fifo_base_sequence;
    `uvm_object_utils(fifo_fill_sequence)
    function new(string name = "fifo_fill_sequence"); super.new(name); endfunction

    virtual task body();
        `uvm_info("SEQ", "Starting Fill Sequence", UVM_LOW)
        repeat(10) begin // Depth is 8, repeat 10 to ensure overflow condition is tested
            req = fifo_transaction::type_id::create("req");
            start_item(req);
            if (!req.randomize() with {wr_en == 1; rd_en == 0;}) begin
                `uvm_error("SEQ", "Random fail")
            end
            finish_item(req);
        end
    endtask
endclass

// --- 2. Empty the FIFO until it is empty ---
class fifo_empty_sequence extends fifo_base_sequence;
    `uvm_object_utils(fifo_empty_sequence)
    function new(string name = "fifo_empty_sequence"); super.new(name); endfunction

    virtual task body();
        `uvm_info("SEQ", "Starting Empty Sequence", UVM_LOW)
        repeat(10) begin
            req = fifo_transaction::type_id::create("req");
            start_item(req);
            if (!req.randomize() with {wr_en == 0; rd_en == 1;}) begin
                `uvm_error("SEQ", "Random fail")
            end
            finish_item(req);
        end
    endtask
endclass

// --- 3. Simultaneous Read and Write ---
class fifo_simul_rw_sequence extends fifo_base_sequence;
    `uvm_object_utils(fifo_simul_rw_sequence)
    function new(string name = "fifo_simul_rw_sequence"); super.new(name); endfunction

    virtual task body();
        `uvm_info("SEQ", "Starting Simultaneous R/W Sequence", UVM_LOW)
        repeat(20) begin
            req = fifo_transaction::type_id::create("req");
            start_item(req);
            if (!req.randomize() with {wr_en == 1; rd_en == 1;}) begin
                `uvm_error("SEQ", "Random fail")
            end
            finish_item(req);
        end
    endtask
endclass

// --- 4. Enhanced Random Sequence ---
class fifo_random_sequence extends fifo_base_sequence;
    `uvm_object_utils(fifo_random_sequence)
    function new(string name = "fifo_random_sequence"); super.new(name); endfunction

    virtual task body();
        `uvm_info("SEQ", "Starting Random Sequence", UVM_LOW)
        repeat(100) begin
            req = fifo_transaction::type_id::create("req");
            start_item(req);
            if (!req.randomize()) begin // Allow all combinations
                `uvm_error("SEQ", "Random fail")
            end
            finish_item(req);
        end
    endtask
endclass

// --- 5. Data Coverage Sequence (Targeting zeros, ones, low_range) ---
class fifo_data_coverage_sequence extends fifo_base_sequence;
    `uvm_object_utils(fifo_data_coverage_sequence)
    function new(string name = "fifo_data_coverage_sequence"); super.new(name); endfunction

    virtual task body();
        `uvm_info("SEQ", "Starting Data Coverage Sequence", UVM_LOW)
        
        // Target 'zeros' bin
        repeat(2) begin
            req = fifo_transaction::type_id::create("req");
            start_item(req);
            if (!req.randomize() with {wr_en == 1; data_in == 32'h0000_0000;}) `uvm_error("SEQ", "Random fail")
            finish_item(req);
        end

        // Target 'ones' bin
        repeat(2) begin
            req = fifo_transaction::type_id::create("req");
            start_item(req);
            if (!req.randomize() with {wr_en == 1; data_in == 32'hFFFF_FFFF;}) `uvm_error("SEQ", "Random fail")
            finish_item(req);
        end

        // Target 'low_range' bin
        repeat(5) begin
            req = fifo_transaction::type_id::create("req");
            start_item(req);
            if (!req.randomize() with {wr_en == 1; data_in inside {[1:100]};}) `uvm_error("SEQ", "Random fail")
            finish_item(req);
        end
    endtask
endclass