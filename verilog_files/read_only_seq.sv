package read_only_seq_pkg;
import uvm_pkg::*;
import fifo_seq_item_pkg::*;
`include "uvm_macros.svh"

class read_only_seq extends uvm_sequence #(fifo_seq_item);
`uvm_object_utils(read_only_seq)
	fifo_seq_item main_seq;
	int j;

	function new(string name = "read_only_seq");
		super.new(name);
	endfunction

	task body;
	repeat(18) begin
		main_seq = fifo_seq_item::type_id::create("main_seq");
		start_item(main_seq);
		//assert(main_seq.randomize());
		main_seq.rd_en = 1;
		main_seq.rst_n = 1;
		main_seq.data_in = $random;
		if(j==18)
			main_seq.wr_en = 1;
		else
			main_seq.wr_en = 0;
		
		j++;

		finish_item(main_seq);

	end
	endtask
endclass
endpackage
