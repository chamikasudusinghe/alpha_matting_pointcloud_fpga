  
module processor 
# (parameter WIDTH = 16)
(
    input clk,
    output proc_state
);
// wire clk = CLOCK_50;
wire [(WIDTH)-1:0] INS;                                             //iROM output  
wire [(WIDTH)-1:0] PC_addr;                                         //PC out to imem controller
wire [(WIDTH)-1:0] MEMWRITE_data;                                   //writing data to dram
wire [(WIDTH)-1:0] DRAM_addr;                                       //dram accessing memory location address
wire [(WIDTH)-1:0] MEMREAD_data;                                    //dram output

wire iROMREAD;
wire memWRITE;
wire memREAD;
wire imemAV1, imemAV2, imemAV3, imemAV4, imemAV5, imemAV6, imemAV7, imemAV8;
wire iROMREAD_1, iROMREAD_2, iROMREAD_3,iROMREAD_4, iROMREAD_5, iROMREAD_6, iROMREAD_7, iROMREAD_8;
wire coreS_1, coreS_2, coreS_3,coreS_4, coreS_5, coreS_6, coreS_7, coreS_8;
wire [WIDTH-1:0] PC_1, PC_2, PC_3,PC_4, PC_5, PC_6, PC_7, PC_8;
wire [WIDTH-1:0]INS_1, INS_2, INS_3,INS_4, INS_5, INS_6, INS_7, INS_8;
wire [WIDTH-1:0] AR_1, AR_2, AR_3,AR_4, AR_5, AR_6, AR_7, AR_8;
wire [WIDTH-1:0] DR_1, DR_2, DR_3, DR_4, DR_5, DR_6, DR_7, DR_8;  
wire memREAD_1, memREAD_2, memREAD_3,memREAD_4, memREAD_5, memREAD_6, memREAD_7, memREAD_8;
wire memWE_1, memWE_2, memWE_3,memWE_4, memWE_5, memWE_6, memWE_7, memWE_8;
wire [WIDTH-1:0] MEM_1, MEM_2, MEM_3,MEM_4, MEM_5, MEM_6, MEM_7, MEM_8;      
wire memAV1, memAV2, memAV3,memAV4, memAV5, memAV6, memAV7, memAV8;
wire nextLoop1, nextLoop2, nextLoop3, nextLoop4, nextLoop5, nextLoop6, nextLoop7, nextLoop8;
// localparam MEMID_CORE1 = 8'd127;                                    //DRAM Store starting locations for respective cores
// localparam MEMID_CORE4 = 8'd159;
// localparam MEMID_CORE2 = 8'd191;
// localparam MEMID_CORE3 = 8'd223;

localparam MEMID_CORE1 = 8'd127;
localparam MEMID_CORE8 = 8'd143;
localparam MEMID_CORE4 = 8'd159;
localparam MEMID_CORE5 = 8'd175;
localparam MEMID_CORE2 = 8'd191;
localparam MEMID_CORE7 = 8'd207;
localparam MEMID_CORE3 = 8'd223;
localparam MEMID_CORE6 = 8'd239;



localparam COREID_1 = 3'd0;
localparam COREID_2 = 3'd1;
localparam COREID_3 = 3'd2;
localparam COREID_4 = 3'd3;
localparam COREID_5 = 3'd4;
localparam COREID_6 = 3'd5;
localparam COREID_7 = 3'd6;
localparam COREID_8 = 3'd7;

//instruction memory
ins_mem #(.ADDR_WIDTH(WIDTH), .INS_WIDTH(WIDTH)) ins_mem(.instruction(INS), .PC_address(PC_addr), .clk(clk), .rEn(iROMREAD));

//data memory
data_mem #(.DATA_WIDTH(WIDTH), .ADDR_WIDTH(WIDTH)) dt_mem(.data(MEMWRITE_data), .addr(DRAM_addr), .wEn(memWRITE), .clk(clk), .mem_out(MEMREAD_data), .rEn(memREAD), .nextLoop(nextLoop1));

imem_controller #(.WIDTH(WIDTH)) imem_c(.Clk(clk), .INS(INS), .rEN(iROMREAD), .PC_OUT(PC_addr), 
 .iROMREAD_1(iROMREAD_1), .iROMREAD_2(iROMREAD_2), .iROMREAD_3(iROMREAD_3), .iROMREAD_4(iROMREAD_4), .iROMREAD_5(iROMREAD_5), .iROMREAD_6(iROMREAD_6), .iROMREAD_7(iROMREAD_7), .iROMREAD_8(iROMREAD_8), 
 .coreS_1(coreS_1), .coreS_2(coreS_2), .coreS_3(coreS_3), .coreS_4(coreS_4), .coreS_5(coreS_5), .coreS_6(coreS_6), .coreS_7(coreS_7), .coreS_8(coreS_8),
 .PC_1(PC_1), .PC_2(PC_2), .PC_3(PC_3), .PC_4(PC_4), .PC_5(PC_5), .PC_6(PC_6), .PC_7(PC_7), .PC_8(PC_8),
 .INS_1(INS_1), .INS_2(INS_2), .INS_3(INS_3), .INS_4(INS_4), .INS_5(INS_5), .INS_6(INS_6), .INS_7(INS_7), .INS_8(INS_8), 
 .imemAV1(imemAV1), .imemAV2(imemAV2), .imemAV3(imemAV3), .imemAV4(imemAV4), .imemAV5(imemAV5), .imemAV6(imemAV6), .imemAV7(imemAV7), .imemAV8(imemAV8));


dmem_controller #(.WIDTH(WIDTH)) dmem_c (.Clk(clk), .MEM(MEMREAD_data), .rEN(memREAD), .wEN(memWRITE), .DR_OUT(MEMWRITE_data), .addr(DRAM_addr),
.coreS_1(coreS_1), .coreS_2(coreS_2), .coreS_3(coreS_3), .coreS_4(coreS_4), .coreS_5(coreS_5), .coreS_6(coreS_6), .coreS_7(coreS_7), .coreS_8(coreS_8),
.memAV1(memAV1), .memAV2(memAV2), .memAV3(memAV3), .memAV4(memAV4), .memAV5(memAV5), .memAV6(memAV6), .memAV7(memAV7), .memAV8(memAV8),
.AR_1(AR_1), .AR_2(AR_2), .AR_3(AR_3), .AR_4(AR_4), .AR_5(AR_5), .AR_6(AR_6), .AR_7(AR_7), .AR_8(AR_8),
.DR_1(DR_1), .DR_2(DR_2), .DR_3(DR_3), .DR_4(DR_4), .DR_5(DR_5), .DR_6(DR_6), .DR_7(DR_7), .DR_8(DR_8),
.memREAD_1(memREAD_1), .memREAD_2(memREAD_2), .memREAD_3(memREAD_3), .memREAD_4(memREAD_4), .memREAD_5(memREAD_5), .memREAD_6(memREAD_6), .memREAD_7(memREAD_7), .memREAD_8(memREAD_8),
.memWE_1(memWE_1), .memWE_2(memWE_2), .memWE_3(memWE_3), .memWE_4(memWE_4), .memWE_5(memWE_5), .memWE_6(memWE_6), .memWE_7(memWE_7), .memWE_8(memWE_8), 
.MEM_1(MEM_1), .MEM_2(MEM_2), .MEM_3(MEM_3), .MEM_4(MEM_4),.MEM_5(MEM_5), .MEM_6(MEM_6), .MEM_7(MEM_7), .MEM_8(MEM_8) );


core #(.WIDTH(WIDTH)) CORE_0 (.Clk(clk), .IROM_dataIn(INS_1), .DRAM_dataIn(MEM_1),.DRAM_dataOut(DR_1), 
                            .IROM_addr(PC_1), .DRAM_addr(AR_1), .memREAD(memREAD_1), .memWRITE(memWE_1), 
                            .iROMREAD(iROMREAD_1), .coreS(coreS_1), 
                            .imemAV(imemAV1), .memAV(memAV1), .MEM_ID(MEMID_CORE1), .coreID(COREID_1), .nextLoop(nextLoop1));

core #(.WIDTH(WIDTH)) CORE_1 (.Clk(clk), .IROM_dataIn(INS_2), .DRAM_dataIn(MEM_2),.DRAM_dataOut(DR_2), 
                            .IROM_addr(PC_2), .DRAM_addr(AR_2), .memREAD(memREAD_2), .memWRITE(memWE_2), .iROMREAD(iROMREAD_2), .coreS(coreS_2), 
                            .imemAV(imemAV2), .memAV(memAV2), .MEM_ID(MEMID_CORE2), .coreID(COREID_2), .nextLoop(nextLoop2));

core #(.WIDTH(WIDTH)) CORE_2 (.Clk(clk), .IROM_dataIn(INS_3), .DRAM_dataIn(MEM_3),.DRAM_dataOut(DR_3), 
                            .IROM_addr(PC_3), .DRAM_addr(AR_3), .memREAD(memREAD_3), .memWRITE(memWE_3), .iROMREAD(iROMREAD_3), .coreS(coreS_3), 
                            .imemAV(imemAV3), .memAV(memAV3), .MEM_ID(MEMID_CORE3), .coreID(COREID_3), .nextLoop(nextLoop3));

core #(.WIDTH(WIDTH)) CORE_3 (.Clk(clk), .IROM_dataIn(INS_4), .DRAM_dataIn(MEM_4),.DRAM_dataOut(DR_4), 
                            .IROM_addr(PC_4), .DRAM_addr(AR_4), .memREAD(memREAD_4), .memWRITE(memWE_4), .iROMREAD(iROMREAD_4), .coreS(coreS_4), 
                            .imemAV(imemAV4), .memAV(memAV4), .MEM_ID(MEMID_CORE4), .coreID(COREID_4), .nextLoop(nextLoop4));

core #(.WIDTH(WIDTH)) CORE_4 (.Clk(clk), .IROM_dataIn(INS_5), .DRAM_dataIn(MEM_5),.DRAM_dataOut(DR_5), 
                            .IROM_addr(PC_5), .DRAM_addr(AR_5), .memREAD(memREAD_5), .memWRITE(memWE_5), .iROMREAD(iROMREAD_5), .coreS(coreS_5), 
                            .imemAV(imemAV5), .memAV(memAV5), .MEM_ID(MEMID_CORE5), .coreID(COREID_5), .nextLoop(nextLoop5));

core #(.WIDTH(WIDTH)) CORE_5 (.Clk(clk), .IROM_dataIn(INS_6), .DRAM_dataIn(MEM_6),.DRAM_dataOut(DR_6), 
                            .IROM_addr(PC_6), .DRAM_addr(AR_6), .memREAD(memREAD_6), .memWRITE(memWE_6), .iROMREAD(iROMREAD_6), .coreS(coreS_6), 
                            .imemAV(imemAV6), .memAV(memAV6), .MEM_ID(MEMID_CORE6), .coreID(COREID_6), .nextLoop(nextLoop6));

core #(.WIDTH(WIDTH)) CORE_6 (.Clk(clk), .IROM_dataIn(INS_7), .DRAM_dataIn(MEM_7),.DRAM_dataOut(DR_7), 
                            .IROM_addr(PC_7), .DRAM_addr(AR_7), .memREAD(memREAD_7), .memWRITE(memWE_7), .iROMREAD(iROMREAD_7), .coreS(coreS_7), 
                            .imemAV(imemAV4), .memAV(memAV7), .MEM_ID(MEMID_CORE7), .coreID(COREID_7), .nextLoop(nextLoop7));

core #(.WIDTH(WIDTH)) CORE_7 (.Clk(clk), .IROM_dataIn(INS_8), .DRAM_dataIn(MEM_8),.DRAM_dataOut(DR_8), 
                            .IROM_addr(PC_8), .DRAM_addr(AR_8), .memREAD(memREAD_8), .memWRITE(memWE_8), .iROMREAD(iROMREAD_8), .coreS(coreS_8), 
                            .imemAV(imemAV8), .memAV(memAV8), .MEM_ID(MEMID_CORE8), .coreID(COREID_8), .nextLoop(nextLoop8));
assign proc_state = (coreS_1 && coreS_2 && coreS_3 && coreS_4 && coreS_5 && coreS_6 && coreS_7 && coreS_8);

endmodule