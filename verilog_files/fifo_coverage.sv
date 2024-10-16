package fifo_coverage_pkg;
import fifo_seq_item_pkg::*;
import uvm_pkg::*;
import fifo_seq_item_pkg::*;
import comm_pkg::*;
`include "uvm_macros.svh"
class fifo_coverage extends uvm_component;
	`uvm_component_utils(fifo_coverage)
	uvm_analysis_export #(fifo_seq_item) cov_export;
	uvm_tlm_analysis_fifo #(fifo_seq_item) cov_fifo;
	fifo_seq_item seq_item_cov;

	//covergroup
	covergroup cvr_gp;
		wr_enable_cp: coverpoint seq_item_cov.wr_en;
		rd_enable_cp: coverpoint seq_item_cov.rd_en;

      // Coverpoints for each output control signal
		wr_ack_cp: coverpoint seq_item_cov.wr_ack;
		overflow_cp: coverpoint seq_item_cov.overflow;
		full_cp: coverpoint seq_item_cov.full;
		empty_cp: coverpoint seq_item_cov.empty;
		almostfull_cp: coverpoint seq_item_cov.almostfull;
		almostempty_cp: coverpoint seq_item_cov.almostempty;
		underflow_cp: coverpoint seq_item_cov.underflow;

      // Cross coverage for write enable, read enable, and all output control signals
		wr_rd_wrACK_cross: cross wr_enable_cp, rd_enable_cp, wr_ack_cp;
		wr_rd_overflow_cross: cross wr_enable_cp, rd_enable_cp, overflow_cp;
		wr_rd_full_cross: cross wr_enable_cp, rd_enable_cp, full_cp;
		wr_rd_empty_cross: cross wr_enable_cp, rd_enable_cp, empty_cp;
		wr_rd_almostfull_cross: cross wr_enable_cp, rd_enable_cp, almostfull_cp;
		wr_rd_almostempty_cross: cross wr_enable_cp, rd_enable_cp, almostempty_cp;
		wr_rd_underflow_cross: cross wr_enable_cp, rd_enable_cp, underflow_cp;
	endgroup


	function new(string name = "fifo_coverage", uvm_component parent = null);
		super.new(name,parent);
		cvr_gp = new();
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		cov_export = new("cov_export", this);
		cov_fifo = new("cov_fifo", this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		cov_export.connect(cov_fifo.analysis_export);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			cov_fifo.get(seq_item_cov);
			cvr_gp.sample();
		end
	endtask
endclass
endpackage
