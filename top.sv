import uvm_pkg::*;
import fifo_test_pkg::*;
`include "uvm_macros.svh"
 
module top();
	bit clk;

	initial begin
		forever
		#1 clk = ~clk;
	end

	fifo_if fif(clk);
	FIFO DUT(fif);
	golden_FIFO REF(fif);
	bind FIFO SVA SVA_inst(fif);

	initial begin
		uvm_config_db#(virtual fifo_if)::set(null, "uvm_test_top", "FIFO_IF", fif);
		run_test("fifo_test"); //the name of the class
	end
endmodule
