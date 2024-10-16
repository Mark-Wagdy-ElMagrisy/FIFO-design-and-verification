import comm_pkg::*;
module SVA(fifo_if.DUT fif);

	// Assertions for Combinational Outputs
	always_comb begin
		if (fif.count == 0) begin
			EMPTY_assertion : assert (fif.empty && !fif.full && !fif.almostempty && !fif.almostfull) else $display("EMPTY_assertion fail");
			EMPTY_cover     : cover  (fif.empty && !fif.full && !fif.almostempty && !fif.almostfull)      $display("EMPTY_assertion Pass");
		end
		if (fif.count == 1) begin
			ALMOSTEMPTY_assertion : assert (!fif.empty && !fif.full && fif.almostempty && !fif.almostfull) else $display("ALMOSTFULL_assertion fail");
			ALMOSTEMPTY_cover     : cover  (!fif.empty && !fif.full && fif.almostempty && !fif.almostfull)      $display("ALMOSTFULL_assertion Pass");
		end
		if (fif.count == fif.FIFO_DEPTH-1) begin
			ALMOSTFULL_assertion : assert (!fif.empty && !fif.full && !fif.almostempty && fif.almostfull) else $display("ALMOSTFULL_assertion fail");
			ALMOSTFULL_cover     : cover  (!fif.empty && !fif.full && !fif.almostempty && fif.almostfull)      $display("ALMOSTEMPTY_assertion Pass");
		end
		if (fif.count == fif.FIFO_DEPTH) begin
			FULL_assertion : assert (!fif.empty && fif.full && !fif.almostempty && !fif.almostfull) else $display("FULL_assertion fail");
			FULL_cover     : cover  (!fif.empty && fif.full && !fif.almostempty && !fif.almostfull)      $display("FULL_assertion Pass");
		end
	end

	// Assertions for Overflow and Underflow
	property OVERFLOW_FIFO;
		@(posedge fif.clk) disable iff (!fif.rst_n) (fif.full & fif.wr_en) |=> (fif.overflow);
	endproperty

	property UNDERFLOW_FIFO;
		@(posedge fif.clk) disable iff (!fif.rst_n) (fif.empty && fif.rd_en) |=> (fif.underflow);
	endproperty

	// Assertions for wr_ack
	property WR_ACK_HIGH;
		@(posedge fif.clk) disable iff (!fif.rst_n) (fif.wr_en && (fif.count < fif.FIFO_DEPTH) && !fif.full) |=> (fif.wr_ack);
	endproperty

	property WR_ACK_LOW;
		@(posedge fif.clk) disable iff (!fif.rst_n) (fif.wr_en && fif.full) |=> (!fif.wr_ack);
	endproperty

	// Assertions for The Counter
	property COUNT_0;
		@(posedge fif.clk) (!fif.rst_n) |=> (fif.count == 0);
	endproperty

	property COUNT_INC_10;
		@(posedge fif.clk) disable iff (!fif.rst_n) (({fif.wr_en, fif.rd_en} == 2'b10) && !fif.full) |=> (fif.count == $past(fif.count) + 1);
	endproperty

	property COUNT_INC_01;
		@(posedge fif.clk) disable iff (!fif.rst_n) (({fif.wr_en, fif.rd_en} == 2'b01) && !fif.empty) |=> (fif.count == $past(fif.count) - 1);
	endproperty

	property COUNT_INC_11_WR;
		@(posedge fif.clk) disable iff (!fif.rst_n) (({fif.wr_en, fif.rd_en} == 2'b11) && fif.empty) |=> (fif.count == $past(fif.count) + 1);
	endproperty

	property COUNT_INC_11_RD;
		@(posedge fif.clk) disable iff (!fif.rst_n) (({fif.wr_en, fif.rd_en} == 2'b11) && fif.full) |=> (fif.count == $past(fif.count) - 1);
	endproperty

	property COUNT_LAT;
		@(posedge fif.clk) disable iff (!fif.rst_n) ((({fif.wr_en, fif.rd_en} == 2'b01) && fif.empty) || (({fif.wr_en, fif.rd_en} == 2'b10) && fif.full))
		|=> (fif.count == $past(fif.count));
	endproperty

	// Assertions for Pointers
	property PTR_RST;
		@(posedge fif.clk) (!fif.rst_n) |=> (~fif.rd_ptr && ~fif.wr_ptr);
	endproperty

	property RD_PTR;
		@(posedge fif.clk) disable iff (!fif.rst_n) (fif.rd_en && (fif.count != 0)) |=> (fif.rd_ptr == ($past(fif.rd_ptr) + 1) % fif.FIFO_DEPTH);
	endproperty

	property WR_PTR;
		@(posedge fif.clk) disable iff (!fif.rst_n) (fif.wr_en && (fif.count < fif.FIFO_DEPTH))
		|=> (fif.wr_ptr == ($past(fif.wr_ptr) + 1) % fif.FIFO_DEPTH);
	endproperty

	// Assert Properties
	OVERFLOW_assertion          : assert property (OVERFLOW_FIFO)    else $display("OVERFLOW_assertion");
	UNDERFLOW_assertion         : assert property (UNDERFLOW_FIFO)   else $display("UNDERFLOW_assertion");
	WR_ACK_HIGH_assertion       : assert property (WR_ACK_HIGH)      else $display("WR_ACK_HIGH_assertion");
	WR_ACK_LOW_assertion        : assert property (WR_ACK_LOW)       else $display("WR_ACK_LOW_assertion");
	COUNTER_0_assertion         : assert property (COUNT_0)          else $display("COUNTER_0_assertion");
	COUNTER_INC_10_assertion    : assert property (COUNT_INC_10)     else $display("COUNTER_INC_WR_assertion fail");
	COUNTER_INC_01_assertion    : assert property (COUNT_INC_01)     else $display("COUNTER_INC_WR_assertion fail");
	COUNTER_INC_11_WR_assertion : assert property (COUNT_INC_11_WR)  else $display("COUNTER_INC_WR_assertion fail");
	COUNTER_INC_11_RD_assertion : assert property (COUNT_INC_11_RD)  else $display("COUNTER_INC_WR_assertion fail");
	COUNTER_LAT_assertion       : assert property (COUNT_LAT)        else $display("COUNTER_LAT_assertion fail");
	PTR_RST_assertion           : assert property (PTR_RST)          else $display("PTR_RST_asssertion fail");
	RD_PTR_assertion            : assert property (RD_PTR)           else $display("RD_PTR_asssertion fail");
	WR_PTR_assertion            : assert property (WR_PTR)           else $display("WR_PTR_asssertion fail");

	// Cover Properties
	OVERFLOW_cover          : cover property (OVERFLOW_FIFO)    $display("OVERFLOW_assertion");
	UNDERFLOW_cover         : cover property (UNDERFLOW_FIFO)   $display("UNDERFLOW_assertion");
	WR_ACK_HIGH_cover       : cover property (WR_ACK_HIGH)      $display("WR_ACK_HIGH_assertion");
	WR_ACK_LOW_cover        : cover property (WR_ACK_LOW)       $display("WR_ACK_LOW_assertion");
	COUNTER_0_cover         : cover property (COUNT_0)          $display("COUNTER_0_assertion");
	COUNTER_INC_10_cover    : cover property (COUNT_INC_10)     $display("COUNTER_INC_WR_assertion Pass");
	COUNTER_INC_01_cover    : cover property (COUNT_INC_01)     $display("COUNTER_INC_WR_assertion Pass");
	COUNTER_INC_11_WR_cover : cover property (COUNT_INC_11_WR)  $display("COUNTER_INC_WR_assertion Pass");
	COUNTER_INC_11_RD_cover : cover property (COUNT_INC_11_RD)  $display("COUNTER_INC_WR_assertion Pass");
	COUNTER_LAT_cover       : cover property (COUNT_LAT)        $display("COUNTER_LAT_assertion Pass");
	PTR_RST_cover           : cover property (PTR_RST)          $display("PTR_RST_asssertion pass");
	RD_PTR_cover            : cover property (RD_PTR)           $display("RD_PTR_asssertion pass");
	WR_PTR_cover            : cover property (WR_PTR)           $display("WR_PTR_asssertion pass");

endmodule