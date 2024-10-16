package fifo_seq_item_pkg;
import comm_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class fifo_seq_item extends uvm_sequence_item;
`uvm_object_utils(fifo_seq_item)

	parameter FIFO_WIDTH = 16;
	parameter FIFO_DEPTH = 8;

	logic clk;
	rand logic [FIFO_WIDTH-1:0] data_in;
	rand logic rst_n, wr_en, rd_en;
	logic [FIFO_WIDTH-1:0] data_out;
	logic wr_ack, overflow;
	logic full, empty, almostfull, almostempty, underflow;

	logic [FIFO_WIDTH-1:0] data_out_ref;
	logic wr_ack_ref, overflow_ref;
	logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;


	function new(string name = "fifo_seq_item");
		super.new(name);
	endfunction


	function string convert2string();
		return $sformatf("%s convert2string called", super.convert2string());
	endfunction

	function string convert2string_stimulus();
		return $sformatf("convert2string_stimulus called");
	endfunction


endclass
endpackage
