package reset_seq_pkg;
import uvm_pkg::*;
import fifo_seq_item_pkg::*;
`include "uvm_macros.svh"

class reset_seq extends uvm_sequence #(fifo_seq_item);
`uvm_object_utils(reset_seq)
fifo_seq_item main_seq;

	function new(string name = "reset_seq");
		super.new(name);
	endfunction

	task body;
		main_seq = fifo_seq_item::type_id::create("main_seq");
		start_item(main_seq);

		main_seq.rst_n=0;
		main_seq.data_in = 0;
		main_seq.rst_n = 0;
		main_seq.wr_en = 0;
		main_seq.rd_en = 0;

		finish_item(main_seq);
	endtask
endclass
endpackage
