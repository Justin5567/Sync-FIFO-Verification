package fifo_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "fifo_transaction.sv"
    `include "fifo_driver.sv"
    `include "fifo_monitor.sv"
    `include "fifo_scoreboard.sv"
    `include "fifo_agent.sv"
    `include "fifo_env.sv"
    `include "fifo_sequence.sv"
endpackage : fifo_pkg