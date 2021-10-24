`timescale 1ns/1ps

module Reg_module_RI_tb ();

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
    reg RST, INC;
    wire [WIDTH-1:0] dout;

    Reg_module_RI #(.WIDTH(WIDTH)) dut (.Clk(Clk), .RST(RST), .INC(INC), .BusOut(BusOut), .dout(dout));
    

    initial begin
        @(posedge Clk);
        RST <= 1;

        #(CLK_PERIOD*2);
        @(posedge Clk);
        RST <= 0;
        BusOut <= 8'b10101010;
        INC <= 1;
      

        #(CLK_PERIOD*2);
        @(posedge Clk);
        RST <= 0;
        BusOut = 8'b10000100;
        INC <= 0;
     

        repeat(5) @(posedge Clk) begin
            BusOut<= $random;
            RST <= $random;
            INC <= $random;
            $display("%8b", BusOut);
        end
        

        $stop;

        
    end


    
endmodule

