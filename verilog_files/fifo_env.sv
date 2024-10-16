package fifo_env_pkg;
import uvm_pkg::*;
import fifo_agent_pkg::*;
import fifo_score_pkg::*;
import fifo_coverage_pkg::*;
`include "uvm_macros.svh"
class fifo_env extends uvm_env;
	`uvm_component_utils(fifo_env)
 
	fifo_agent agt;
	fifo_score scr;
	fifo_coverage cvr;
 
	function new(string name = "fifo_env", uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agt = fifo_agent::type_id::create("agt", this);
		scr = fifo_score::type_id::create("scr", this);
		cvr = fifo_coverage::type_id::create("cvr", this);
	endfunction

	function void connect_phase(uvm_phase phase);
		agt.agt_port.connect(scr.sb_export);
		agt.agt_port.connect(cvr.cov_export);
	endfunction

endclass
endpackage
