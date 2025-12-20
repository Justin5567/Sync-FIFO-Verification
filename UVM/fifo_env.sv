import uvm_pkg::*;
`include "uvm_macros.svh"

class fifo_env extends uvm_env;
    `uvm_component_utils(fifo_env)
    fifo_agent      agent;
    fifo_scoreboard scoreboard;

    function new(string name, uvm_component parent); super.new(name, parent); endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = fifo_agent::type_id::create("agent", this);
        scoreboard = fifo_scoreboard::type_id::create("scoreboard", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        agent.monitor.ap.connect(scoreboard.item_got_export);
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
        fifo_random_sequence seq;
        seq = fifo_random_sequence::type_id::create("seq");

        phase.raise_objection(this); 
        
        #10ns; 
    
        seq.start(env.agent.sequencer);
        
        #100ns; 
        phase.drop_objection(this); 
    endtask
endclass
