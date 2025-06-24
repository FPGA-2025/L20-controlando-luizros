module fsm(
    input   clk,
    input   rst_n,

    output reg wr_en,

    output [7:0] fifo_data,
    
    input [3:0] fifo_words
);

    assign fifo_data = 8'hAA;

    localparam ESCREVE = 1'b0, ESPERA = 1'b1;
    reg state, next_state;

    always @(*) begin
        case (state)
            ESCREVE: begin
                if (fifo_words >= 5)
                    next_state = ESPERA;
                else
                    next_state = ESCREVE;
            end
            ESPERA: begin
                if (fifo_words <= 2)
                    next_state = ESCREVE;
                else
                    next_state = ESPERA;
            end
            default: next_state = ESCREVE;
        endcase
    end

    always @(posedge clk) begin
        if (!rst_n)
            state <= ESCREVE;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            ESCREVE: wr_en = 1'b1;
            ESPERA:  wr_en = 1'b0;
            default: wr_en = 1'b0;
        endcase
    end

endmodule