interface fifo_if(clk);
	input clk;
	parameter FIFO_WIDTH = 16;
	parameter FIFO_DEPTH = 8;
	logic [fif.FIFO_WIDTH-1:0] data_in;
	logic rst_n, wr_en, rd_en;
	logic [fif.FIFO_WIDTH-1:0] data_out;
	logic wr_ack, overflow;
	logic full, empty, almostfull, almostempty, underflow;

	localparam max_fifo_addr = $clog2(fif.FIFO_DEPTH);

	reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
	reg [max_fifo_addr:0] count;

	logic [fif.FIFO_WIDTH-1:0] data_out_ref;
	logic wr_ack_ref, overflow_ref;
	logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;

	reg [max_fifo_addr-1:0] wr_ptr_ref, rd_ptr_ref;
	reg [max_fifo_addr:0] count_ref;

	modport DUT (input clk, data_in, rst_n, wr_en, rd_en,
			output data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow,
			wr_ptr, rd_ptr, count);

	modport REF (input clk, data_in, rst_n, wr_en, rd_en,
			output data_out_ref, wr_ack_ref, overflow_ref, full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref,
			wr_ptr_ref, rd_ptr_ref, count_ref);
endinterface
