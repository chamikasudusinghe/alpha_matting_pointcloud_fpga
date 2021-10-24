`timescale 1ns/1ps
`include "proc_param.v"
module core_tb ();

    localparam CLK_PERIOD = 20;
    reg Clk;

    initial begin
        Clk = 1'b1;
        forever begin
            #(CLK_PERIOD/2);
            Clk = ~Clk;
        end
    end

    localparam WIDTH=8;
	
    reg [WIDTH-1:0] ram[2**WIDTH-1:0];
	reg [WIDTH-1:0] rom[2**WIDTH-1:0];

    initial begin
        $readmemh("D:\\Academic\\ACA\\SEM5 TRONIC ACA\\SEMESTER 5\\CSD\\FPGA\\FINAL CODE\\ins_mem.txt",rom);
        $readmemh("D:\\Academic\\ACA\\SEM5 TRONIC ACA\\SEMESTER 5\\CSD\\FPGA\\FINAL CODE\\data_mem.txt",ram);
    end

    integer index;

    reg [WIDTH-1:0]IROM_dataIn;
    reg [WIDTH-1:0]DRAM_dataIn;
    wire [WIDTH-1:0]DRAM_dataOut;
    wire [WIDTH-1:0]IROM_addr;
    wire [WIDTH-1:0]DRAM_addr;
    wire memREAD;
    wire memWRITE;
    wire iROMREAD;
    wire coreS;
    initial begin
        IROM_dataIn <= rom[0];
        DRAM_dataIn <= ram[0];    
    end

    core #(.WIDTH(WIDTH)) dut (.Clk(Clk), .IROM_dataIn(IROM_dataIn), .DRAM_dataIn(DRAM_dataIn), .DRAM_dataOut(DRAM_dataOut), .IROM_addr(IROM_addr), .DRAM_addr(DRAM_addr), .memREAD(memREAD), .memWRITE(memWRITE), .iROMREAD(iROMREAD), .coreS(coreS));

     initial begin
        
        for (index = 0 ;index < 30 ; index= index+ 1 ) begin
            DRAM_dataIn = ram[index];
            $display("%8b", DRAM_dataIn);
        end

        for (index =0 ;index < 50 ; index= index+ 1 ) begin
            $display("%8b", rom[index]);
        end       
        
        @(posedge Clk);
        //#(CLK_PERIOD*1);
        IROM_dataIn <= rom[IROM_addr];
        DRAM_dataIn <= ram[DRAM_addr]; //170        
        #(CLK_PERIOD*3);
        IROM_dataIn <= rom[IROM_addr];
        #(CLK_PERIOD*3);        
        DRAM_dataIn <= ram[DRAM_addr];
        #(CLK_PERIOD*10);

        //@(posedge Clk);
        //#(CLK_PERIOD*2)
        // IROM_dataIn <= 8'b00100000;
        // DRAM_dataIn <= 8'b10101010; //170

        // //#(CLK_PERIOD);
        // @(posedge Clk);
        // IROM_dataIn <= 8'b00100000;
        // DRAM_dataIn <= 8'b10101010; //170
        // #(CLK_PERIOD*10);

        // @(posedge Clk);
        // IROM_dataIn<= 8'b0001_0000;
        // DRAM_dataIn <= 8'b00000011;  //3

        // #(CLK_PERIOD*10);
        // @(posedge Clk);
        // IROM_dataIn <= 8'b01100000;
        // DRAM_dataIn <= 8'b000000001; //1

        // #(CLK_PERIOD*10);
        // @(posedge Clk);
        // IROM_dataIn <= 01100001;
        // DRAM_dataIn <= 8'b00000010; //2

        // #(CLK_PERIOD*10);
        // @(posedge Clk);
        // IROM_dataIn <= 00110000;
        // DRAM_dataIn <= 8'b00000010; //2

        // #(CLK_PERIOD*10);
        // @(posedge Clk);
        // IROM_dataIn <= 01010000;
        // DRAM_dataIn <= 8'b00001110; //14

        // #(CLK_PERIOD*10);
        // @(posedge Clk);
        // IROM_dataIn <= 01010000;
        // DRAM_dataIn <= 8'b00001010; //10

        // #(CLK_PERIOD*10);

        // repeat(3) @(posedge Clk) begin
        //     IROM_dataIn <= $random;
        //     DRAM_dataIn<= $random;

        //     #(CLK_PERIOD*7);
            
        // end
        

        $stop;
         
     end

endmodule