`timescale 1ns/1ps

module Reg_module_RW_tb ();

    localparam CLK_PERIOD = 20;
    reg Clk;

    initial begin
        Clk = 1'b0;
        forever begin
            #(CLK_PERIOD/2);
            Clk = ~Clk;
        end
    end

    localparam WIDTH = 8;
    reg [WIDTH-1:0] BusOut;
    reg WEN, RST;
    wire [WIDTH-1:0] dout;

    Reg_module_RW #(.WIDTH(WIDTH)) dut (.Clk(Clk), .WEN(WEN), .RST(RST), .BusOut(BusOut), .dout(dout));
    

    initial begin
       
        #(CLK_PERIOD*2);
        @(posedge Clk);
        WEN <= 0;
        BusOut <= 8'b10101010;
        RST <= 0;
      

        #(CLK_PERIOD*2);
        @(posedge Clk);
        WEN <= 1;
        BusOut = 8'b10000100;
        RST <= 0;

        #(CLK_PERIOD);
        @(posedge Clk);
        WEN <= 0;
        BusOut = 8'b10000100;
        RST <= 1;
     

        repeat(5) @(posedge Clk) begin
            BusOut<= $random;
            WEN <= $random;
            RST <= $random;
            $display("%8b", BusOut);
        end
        

        $stop;

        
    end


    
endmodule