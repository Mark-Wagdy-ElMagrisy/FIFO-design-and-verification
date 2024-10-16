package fifo_test_pkg;
import uvm_pkg::*;
import fifo_env_pkg::*;
import reset_seq_pkg::*;
import read_only_seq_pkg::*;
import write_only_seq_pkg::*;
import write_read_seq_pkg::*;
`include "uvm_macros.svh"
  
class fifo_test extends uvm_test;
	`uvm_component_utils(fifo_test)

	fifo_env env;
	virtual fifo_if fifo_test_vif;
	//fifo_seq main_seq;
	reset_seq rst_seq;
	read_only_seq rd_seq;
	write_only_seq wr_seq;
	write_read_seq wr_rd;

	function new(string name = "fifo_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = fifo_env::type_id::create("env",this);
		rst_seq = reset_seq::type_id::create("rst_seq");
		rd_seq = read_only_seq::type_id::create("rd_seq");
		wr_seq = write_only_seq::type_id::create("wr_seq");
		wr_rd = write_read_seq::type_id::create("wr_rd");

		uvm_config_db #(virtual fifo_if)::get(this, "", "FIFO_IF", fifo_test_vif);

		uvm_config_db #(virtual fifo_if)::set(this, "*", "VIF", fifo_test_vif);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);

		`uvm_info("run_phase","starting rst seq",UVM_NONE)
		rst_seq.start(env.agt.sqr);

		`uvm_info("run_phase","starting write seq",UVM_NONE)
		wr_seq.start(env.agt.sqr);

		`uvm_info("run_phase","starting read seq",UVM_NONE)
		rd_seq.start(env.agt.sqr);

		`uvm_info("run_phase","starting write seq",UVM_NONE)
		wr_seq.start(env.agt.sqr);

		`uvm_info("run_phase","read-write seq",UVM_NONE)
		wr_rd.start(env.agt.sqr);

		`uvm_info("run_phase","Inside the FIFO test",UVM_NONE)

		phase.drop_objection(this);
	endtask

endclass
endpackage
