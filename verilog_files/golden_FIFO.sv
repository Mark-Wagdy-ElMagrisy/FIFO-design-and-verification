module golden_FIFO(fifo_if.REF fif);

logic [fif.FIFO_WIDTH-1:0] data_in;
logic clk, rst_n, wr_en, rd_en;
logic [fif.FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;

assign data_in = fif.data_in;
assign clk = fif.clk;
assign rst_n = fif.rst_n;
assign wr_en = fif.wr_en;
assign rd_en = fif.rd_en;
assign fif.data_out_ref = data_out;
assign fif.wr_ack_ref = wr_ack;
assign fif.overflow_ref = overflow;
assign fif.full_ref = full;
assign fif.empty_ref = empty;
assign fif.almostfull_ref = almostfull;
assign fif.almostempty_ref = almostempty;
assign fif.underflow_ref = underflow;
 
localparam max_fifo_addr = $clog2(fif.FIFO_DEPTH);

reg [fif.FIFO_WIDTH-1:0] mem [fif.FIFO_DEPTH-1:0];

logic [max_fifo_addr-1:0] wr_ptr, rd_ptr;
logic [max_fifo_addr:0] count;

assign fif.wr_ptr_ref = wr_ptr;
assign fif.rd_ptr_ref = rd_ptr;
assign fif.count_ref = count;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		wr_ptr <= 0;
	end
	else if (wr_en && count < fif.FIFO_DEPTH) begin
		mem[wr_ptr] <= data_in;
		wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		wr_ack <= 0; 
		if (full & wr_en)
			overflow <= 1;
		else
			overflow <= 0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		rd_ptr <= 0;
	end
	else if (rd_en && count != 0) begin
		data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({wr_en, rd_en} == 2'b10) && !full) 
			count <= count + 1;
		else if ( ({wr_en, rd_en} == 2'b01) && !empty)
			count <= count - 1;
	end
end

assign full = (count == fif.FIFO_DEPTH)? 1 : 0;
assign empty = (count == 0)? 1 : 0;
assign underflow = (empty && rd_en)? 1 : 0; 
assign almostfull = (count == fif.FIFO_DEPTH-2)? 1 : 0; 
assign almostempty = (count == 1)? 1 : 0;

endmodule
