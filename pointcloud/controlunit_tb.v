`timescale 1ns/1ps
`include "cu_param.v"
module controlunit_tb ();

    localparam CLK_PERIOD = 20;
    reg Clk;

    initial begin
        Clk = 1'b0;
        forever begin
            #(CLK_PERIOD/2);
            Clk = ~Clk;
        end
    end

    reg zFlag;
    reg [7:0] REG_IR;
    reg iROMREAD;
    reg memREAD;
    reg memWRITE;
    reg [13:0] wEN;
    reg selAR;
    reg [3:0] busMUX;
    reg [5:0] INC;
	 reg [4:0] RST;
    reg [2:0] compMUX;
    reg [2:0] aluOP;

    reg [7:0]NEXT_STATE;
    reg [7:0]INS;
    reg [7:0]MEM_READ;

    controlunit dut (.Clk(Clk), .z(zFlag), .REG_IR(REG_IR), .iROMREAD(iROMREAD), .memREAD(memREAD), .memWRITE(memWRITE), .wEN(wEN), .selAR(selAR), .busMUX(busMUX), .INC(INC), .RST(RST), .compMUX(compMUX), .aluOP(aluOP)) ;
    

    initial begin
        NEXT_STATE <= `FETCH_3;

        #(CLK_PERIOD*2);
        @(posedge Clk);
        REG_IR <= 8'b0001_0000;
        iROMREAD <= 0;
        memREAD <= 0;
        memWRITE <= 0;
        wEN <= 0;
        selAR <= 0;
        busMUX <= 0;
        INC <= 0;
        RST <= 0;
        compMUX <= 0;
        aluOP <= 0;
        $display("%8b", NEXT_STATE);
        $display("%8b", INS);
        $display("%8b", MEM_READ);
        
        NEXT_STATE <= `FETCH_3;


        #(CLK_PERIOD*2);
        @(posedge Clk);
        REG_IR <= 8'b0001_0000;
        iROMREAD <= 0;
        memREAD <= 0;
        memWRITE <= 0;
        wEN <= 0;
        selAR <= 0;
        busMUX <= 0;
        INC <= 0;
        RST <= 0;
        compMUX <= 0;
        aluOP <= 0;
        $display("%8b", NEXT_STATE);
        $display("%8b", INS);
        $display("%8b", MEM_READ);
        
        NEXT_STATE <= `FETCH_3;

        #(CLK_PERIOD);
        @(posedge Clk);
        REG_IR <= 8'b0010_0000;
        iROMREAD <= 0;
        memREAD <= 0;
        memWRITE <= 0;
        wEN <= 0;
        selAR <= 0;
        busMUX <= 0;
        INC <= 0;
        RST <= 0;
        compMUX <= 0;
        aluOP <= 0;
        $display("%8b", NEXT_STATE);
        $display("%8b", INS);
        $display("%8b", MEM_READ);
        
     

        repeat(5) @(posedge Clk) begin
            REG_IR <= $random;
            iROMREAD <= $random;
            memREAD <= $random;
            memWRITE <= $random;
            wEN <= $random;
            selAR <= $random;
            busMUX <= $random;
            INC <= $random;
            RST <= $random;
            compMUX <= $random;
            aluOP <= $random;
            $display("%8b", NEXT_STATE);
            $display("%8b", INS);
            $display("%8b", MEM_READ);
            

        end
        

        $stop;

        
    end


    
endmodule

