package write_read_seq_pkg;
import uvm_pkg::*;
import fifo_seq_item_pkg::*;
`include "uvm_macros.svh"

class write_read_seq extends uvm_sequence #(fifo_seq_item);
`uvm_object_utils(write_read_seq)
fifo_seq_item main_seq;

	function new(string name = "write_read_seq");
		super.new(name);
	endfunction

	task body;
	repeat(2000) begin
		main_seq = fifo_seq_item::type_id::create("main_seq");
		start_item(main_seq);
		assert(main_seq.randomize());
		finish_item(main_seq);
	end
	endtask
endclass
endpackage
