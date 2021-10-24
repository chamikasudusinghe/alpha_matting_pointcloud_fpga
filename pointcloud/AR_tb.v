/*`timescale 1ns/1ps

module AR_tb ();

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
    reg [WIDTH-1:0] BusOut, IOut;
    reg WEN;
    reg selAR;
    wire [WIDTH-1:0] dout;

    AR #(.WIDTH(WIDTH)) dut (.Clk(Clk), .WEN(WEN), .BusOut(BusOut), .IOut(IOut), .selAR(selAR), .dout(dout));
    

    initial begin
       
        #(CLK_PERIOD*2);
        @(posedge Clk);
        WEN <= 0;
        BusOut <= 8'b10101010;
        IOut <= 8'b10001000;
        selAR <= 1'b0; 
    
      

        #(CLK_PERIOD*2);
        @(posedge Clk);
        WEN <= 1;
        BusOut <= 8'b10101010;
        IOut <= 8'b10001000;
        selAR <= 1'b0;
        

        #(CLK_PERIOD);
        @(posedge Clk);
        WEN <= 1;
        BusOut <= 8'b10101010;
        IOut <= 8'b10001000;
        selAR <= 1'b1;
 
     

        repeat(5) @(posedge Clk) begin
            WEN <= $random;
            BusOut <= $random;
            IOut <= $random;
            selAR <= $random;
            $display("%8b", BusOut);
            $display("%8b", IOut);

        end
        

        $stop;

        
    end


    
endmodule*/

`timescale 1ns/1ps

module AR_tb ();

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
    reg [WIDTH-1:0] BusOut, IOut;
    reg WEN;
    reg selAR;
    reg coreINC_AR;
    reg [WIDTH-1:0] coreID;
    wire [WIDTH-1:0] dout;

    AR #(.WIDTH(WIDTH)) dut (.Clk(Clk), .WEN(WEN), .BusOut(BusOut), .IOut(IOut), .selAR(selAR), .dout(dout), .coreID(coreID), .coreINC_AR(coreINC_AR));

    initial begin
       
        #(CLK_PERIOD*2);
        @(posedge Clk);
        WEN <= 1;
        coreID <= 8'b00000001;
        coreINC_AR <= 0;
        BusOut <= 8'b10101010;
        IOut <= 8'b10001000;
        selAR <= 1'b0; 
    
      

        #(CLK_PERIOD*2);
        @(posedge Clk);
        WEN <= 0;
        coreID <= 8'b00000001;
        coreINC_AR <= 1;
        BusOut <= 8'b10101010;
        IOut <= 8'b10001000;
        selAR <= 1'b0;
        

        #(CLK_PERIOD);
        @(posedge Clk);
        WEN <= 1;
        BusOut <= 8'b10101010;
        IOut <= 8'b10001000;
        selAR <= 1'b1;
 
     

        repeat(5) @(posedge Clk) begin
            WEN <= $random;
            coreID <= $random;
            coreINC_AR <= $random;
            BusOut <= $random;
            IOut <= $random;
            selAR <= $random;
            $display("%8b", BusOut);
            $display("%8b", IOut);

        end
        $stop;        
    end


    
endmodule



