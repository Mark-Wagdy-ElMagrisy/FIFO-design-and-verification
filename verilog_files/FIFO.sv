////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(fifo_if.DUT fif);
//parameter FIFO_WIDTH = 16;
//parameter FIFO_DEPTH = 8;
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
assign fif.data_out = data_out;
assign fif.wr_ack = wr_ack;
assign fif.overflow = overflow;
assign fif.full = full;
assign fif.empty = empty;
assign fif.almostfull = almostfull;
assign fif.almostempty = almostempty;
assign fif.underflow = underflow;

//data_in, wr_en, rd_en, clk, rst_n, full, empty, almostfull, almostempty, wr_ack, overflow, underflow, data_out
 
localparam max_fifo_addr = $clog2(fif.FIFO_DEPTH);

reg [fif.FIFO_WIDTH-1:0] mem [fif.FIFO_DEPTH-1:0];


logic [max_fifo_addr-1:0] wr_ptr, rd_ptr;
logic [max_fifo_addr:0] count;

assign fif.wr_ptr = wr_ptr;
assign fif.rd_ptr = rd_ptr;
assign fif.count = count;


	// write operation
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			wr_ptr <= 0;
			overflow <= 0;  //fix: overflow signal should be zero at reset
			wr_ack <= 0;    //fix: write_ack signal should be zero at reset
		end
		else if (wr_en && count < fif.FIFO_DEPTH) begin
			mem[wr_ptr] <= data_in;
			wr_ack <= 1;
			wr_ptr <= wr_ptr + 1;
			overflow <= 0;  //fix: due to FIFO is not full , so overflow should be zero
		end
		else begin 
			wr_ack <= 0; 
			if (full && wr_en)
				overflow <= 1;
			else
				overflow <= 0;
		end
	end

	// read operation
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			rd_ptr <= 0;
			underflow <= 0;   //fix: underflow signal should be zero at reset
			data_out <= 0;    //fix: dataout signal should be zero at reset
		end
		else if (rd_en && count != 0) begin
			data_out <= mem[rd_ptr];
			rd_ptr <= rd_ptr + 1;
			underflow <= 0;    //fix: due to FIFO is not empty , so underflow should be zero
		end

		else begin   //fix : underflow output is sequential output not combinational
			if (rd_en && empty) begin
				underflow <= 1;       //fix
			end
			else begin
				underflow <= 0;        //fix
			end
		end
	end

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			count <= 0;
		end
		else begin
			if (({wr_en, rd_en} == 2'b11) && full) begin 
                    count <= count-1;  //fix: when both wr_en and rd_en are high , and full=1 , only read operation will occur
            end
			else if (({wr_en, rd_en} == 2'b11) && empty) begin  //fix
                    count <= count+1; //fix: when both wr_en and rd_en are high , and empty=1 , only write operation will occur
            end
			else if (({wr_en, rd_en} == 2'b11) && !full && !empty) begin  //fix
                    count <= count; //fix: when both wr_en and rd_en are high , and both empty=0 and full=0 , both operations (read,write) will occur
            end
			else if ( ({wr_en, rd_en} == 2'b10) && !full) 
				count <= count + 1;
			else if ( ({wr_en, rd_en} == 2'b01) && !empty)
				count <= count - 1;
		end
	end

	assign full = (count == fif.FIFO_DEPTH)? 1 : 0;
	assign empty = (count == 0)? 1 : 0;
	assign almostfull = (count == fif.FIFO_DEPTH-1)? 1 : 0; //fix : almostfull signal is high when count=FIFO_DEPTH-1 not FIFO_DEPTH-2
	assign almostempty = (count == 1)? 1 : 0;

endmodule