// package fifo_pkg;                       // package declaration
//   `include "uvm_macros.svh" 
//   import uvm_pkg::*;                  // import UVM package

//   //configs
//   `include "fifo_config.sv"
//   `include "common_config.sv"
//   // Sequence Item
//   `include "fifo_seq_item.sv"
//   // Drivers
//   `include "in_driver.sv"
//   // Monitor
//   `include "in_monitor.sv"
//   // Agents 
//   `include "in_agent.sv"
//   // Scoreboard
//   `include "scoreboard.sv"
//   // Sequences
//   `include "fifo_sequence.sv"
//   // Enironment 
//   `include "env.sv"
//   // Tests
//   `include "fifo_base_test.sv"
//   `include "../test/simple_test.sv"
  
// endpackage 

package fifo_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;

  // ----- CONFIGS (Need to go up one directory to find 'config' folder)
  `include "../config/fifo_config.sv"
  `include "../config/common_config.sv"
  
  // ----- SEQUENCE ITEM (Need to go up one directory to find 'sequence_item' folder)
  `include "../sequence_item/fifo_seq_item.sv"
  
  // ----- DRIVERS, MONITORS, SEQUENCER, AGENT (Need to go up one directory to find 'agent' folder)
  `include "../agent/fifo_sequencer.sv"
  `include "../agent/in_driver.sv"
  `include "../agent/in_monitor.sv"
  `include "../agent/in_agent.sv"
  
  // ----- SCOREBOARD
  `include "../scoreboard/scoreboard.sv"
  
  // ----- SEQUENCES
  `include "../sequence/fifo_sequence.sv"
  
  // ----- ENVIRONMENT 
  `include "../env/env.sv"
  
  // ----- TESTS (These are located one level above the 'package' folder)
  `include "../fifo_base_test.sv"
  
  // ----- SIMPLE_TEST (This is located in 'verif/test/', which is two levels up)
  `include "../../test/simple_test.sv" 
  
endpackage
