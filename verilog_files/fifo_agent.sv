package fifo_agent_pkg;
import uvm_pkg::*;
import fifo_sequencer_pkg::*;
import fifo_driver_pkg::*;
import fifo_monitor_pkg::*;
import fifo_seq_item_pkg::*;
`include "uvm_macros.svh"

class fifo_agent extends uvm_agent;
`uvm_component_utils(fifo_agent)

	virtual fifo_if fifo_agent_vif;
	fifo_sequencer sqr;
	fifo_driver drv;
	fifo_monitor mon;
	uvm_analysis_port #(fifo_seq_item) agt_port;

	function new(string name = "fifo_agent", uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(virtual fifo_if)::get(this, "", "VIF", fifo_agent_vif))
		`uvm_fatal("build_phase", "unable to get configuration object")
		sqr=fifo_sequencer::type_id::create("sqr", this);
		drv=fifo_driver::type_id::create("drv", this);
		mon=fifo_monitor::type_id::create("mon", this);
		agt_port = new("agt_port", this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		drv.fifo_driver_vif = fifo_agent_vif;
		mon.fifo_monitor_vif = fifo_agent_vif;
		drv.seq_item_port.connect(sqr.seq_item_export);
		mon.mon_port.connect(agt_port);
	endfunction
endclass
endpackage
