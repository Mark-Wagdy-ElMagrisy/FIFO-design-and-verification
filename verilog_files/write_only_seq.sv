package write_only_seq_pkg;
import uvm_pkg::*;
import fifo_seq_item_pkg::*;
`include "uvm_macros.svh"

class write_only_seq extends uvm_sequence #(fifo_seq_item);
`uvm_object_utils(write_only_seq)

	fifo_seq_item main_seq;
	int i=0;

	function new(string name = "write_only_seq");
		super.new(name);
	endfunction

	task body;
	repeat(20) begin
		main_seq = fifo_seq_item::type_id::create("main_seq");
		start_item(main_seq);

		main_seq.wr_en = 1;
		main_seq.rst_n = 1;
		main_seq.data_in = $random;

		if(i==14)
			main_seq.rd_en = 1;
		else
			main_seq.rd_en = 0;
		
		i++;
		finish_item(main_seq);
	end
	endtask
endclass
endpackage
