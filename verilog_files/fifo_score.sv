package fifo_score_pkg;
import fifo_seq_item_pkg::*;
import uvm_pkg::*;
import fifo_seq_item_pkg::*;
`include "uvm_macros.svh"
class fifo_score extends uvm_scoreboard;
`uvm_component_utils(fifo_score)
	uvm_analysis_export #(fifo_seq_item) sb_export;
	uvm_tlm_analysis_fifo #(fifo_seq_item) sb_fifo;
	fifo_seq_item fifo_sequence;
	//logic [5:0] out_ref;
	//logic [15:0] leds_ref;

	int error_count = 0;
	int correct_count = 0;

	function new(string name = "fifo_score", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);	//must be void here
		super.build_phase(phase);
		sb_export = new("sb_export", this);
		sb_fifo = new("sb_fifo", this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		sb_export.connect(sb_fifo.analysis_export);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			sb_fifo.get(fifo_sequence);

			if(fifo_sequence.data_out != fifo_sequence.data_out_ref) begin
				`uvm_error("run_phase",
				$sformatf("Comparison failed. Transaction recieved by the DUT:%s while the ref out: 0b%0b",
				fifo_sequence.convert2string(), fifo_sequence.data_out_ref) );

				error_count++;
			end
			else begin
				`uvm_info("run_phase", $sformatf("Correct FIFO out: %s ", fifo_sequence.convert2string()), UVM_MEDIUM);
				correct_count++;
			end
		end
	endtask

endclass
endpackage
