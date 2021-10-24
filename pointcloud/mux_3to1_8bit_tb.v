`timescale 1ns/1ps
module mux_3to1_8bit_tb();

    localparam CLK_PERIOD = 20;
    reg Clk;

    initial begin
        Clk = 1'b0;
        forever begin
            #(CLK_PERIOD/2);
            Clk = ~Clk;
        end
    end

    reg [2:0] mux_sel;
    reg [7:0] mux_inN, mux_inK, mux_inM;
    wire [7:0] mux_out;

    mux_3to1_8bit  dut(.mux_inN(mux_inN), .mux_inK(mux_inK), .mux_inM(mux_inM), .mux_sel(mux_sel), .mux_out(mux_out));

    initial begin
        @(posedge Clk);
        mux_inN=8'b10101010;
        mux_inK = 8'b10000000;
        mux_inM = 8'b10010010;

        #(CLK_PERIOD);
        @(posedge Clk);
        mux_sel = 3'b001;
        mux_inN=8'b10101010;
        mux_inK = 8'b10000000;
        mux_inM = 8'b10010010;

        #(CLK_PERIOD);
        @(posedge Clk);
        mux_sel = 3'b010;
        mux_inN=8'b10101010;
        mux_inK = 8'b10000000;
        mux_inM = 8'b10010010;

        repeat(3) @(posedge Clk) begin
            mux_sel = $random;
            mux_inN = $random;
            mux_inK = $random;
            mux_inM = $random;
          
        end

    end

endmodule




    