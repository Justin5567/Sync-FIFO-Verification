import uvm_pkg::*;
`include "uvm_macros.svh"

class fifo_env extends uvm_env;
    `uvm_component_utils(fifo_env)
    fifo_agent      agent;
    fifo_scoreboard scoreboard;
    fifo_coverage   coverage;

    function new(string name, uvm_component parent); super.new(name, parent); endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = fifo_agent::type_id::create("agent", this);
        scoreboard = fifo_scoreboard::type_id::create("scoreboard", this);
        coverage = fifo_coverage::type_id::create("coverage", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.monitor.ap.connect(scoreboard.item_got_export);
        agent.monitor.ap.connect(coverage.analysis_export);
    endfunction
endclass

class fifo_test extends uvm_test;
    `uvm_component_utils(fifo_test)
    fifo_env env;

    function new(string name, uvm_component parent); super.new(name, parent); endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = fifo_env::type_id::create("env", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        fifo_fill_sequence     fill_seq;
        fifo_empty_sequence    empty_seq;
        fifo_simul_rw_sequence simul_seq;
        fifo_random_sequence   rand_seq;
        fifo_data_coverage_sequence data_seq;

        fill_seq  = fifo_fill_sequence::type_id::create("fill_seq");
        empty_seq = fifo_empty_sequence::type_id::create("empty_seq");
        simul_seq = fifo_simul_rw_sequence::type_id::create("simul_seq");
        rand_seq  = fifo_random_sequence::type_id::create("rand_seq");
        data_seq  = fifo_data_coverage_sequence::type_id::create("data_seq");

        phase.raise_objection(this); 
        
        #10ns; 
        
        `uvm_info("TEST", "Running Data Coverage Sequence...", UVM_LOW)
        data_seq.start(env.agent.sequencer);

        `uvm_info("TEST", "Running Fill Sequence...", UVM_LOW)
        fill_seq.start(env.agent.sequencer);
        
        `uvm_info("TEST", "Running Empty Sequence...", UVM_LOW)
        empty_seq.start(env.agent.sequencer);

        `uvm_info("TEST", "Running Simultaneous R/W Sequence...", UVM_LOW)
        simul_seq.start(env.agent.sequencer);
        
        `uvm_info("TEST", "Running Random Sequence...", UVM_LOW)
        rand_seq.start(env.agent.sequencer);
        
        #100ns; 
        phase.drop_objection(this); 
    endtask
endclass
