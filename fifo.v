module fifo(
    input   clk,
    input   rst_n,

    input   wr_en,
    input   [7:0] data_in,
    output  full,

    input   rd_en,
    output  reg [7:0] data_out,
    output  empty,

    output reg [3:0] fifo_words  
);

    reg [7:0] mem [0:7];
    reg [2:0] wr_ptr, rd_ptr;

    assign full  = (fifo_words == 8);
    assign empty = (fifo_words == 0);

    always @(posedge clk) begin
        if (!rst_n) begin
            wr_ptr     <= 0;
            rd_ptr     <= 0;
            fifo_words <= 0;
            data_out   <= 0;
        end else begin
            if (wr_en && !full) begin
                mem[wr_ptr] <= data_in;
                wr_ptr <= wr_ptr + 1;
            end

            if (rd_en && !empty) begin
                data_out <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 1;
            end

            case ({wr_en && !full, rd_en && !empty})
                2'b10: fifo_words <= fifo_words + 1; // only write
                2'b01: fifo_words <= fifo_words - 1; // only read
                2'b11: fifo_words <= fifo_words;     // both: no change
                2'b00: fifo_words <= fifo_words;     // nothing
            endcase
        end
    end

endmodule