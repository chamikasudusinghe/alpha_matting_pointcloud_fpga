`include "proc_param.v"

module core 

#(parameter WIDTH = 8)(
    input Clk,
    input [WIDTH-1:0]IROM_dataIn,                               // --> IR or --> AR
    input [WIDTH-1:0]DRAM_dataIn,                               // --> DR
    input [WIDTH-1:0] MEM_ID,
    input [2:0] coreID,
    input imemAV, memAV,
    output [WIDTH-1:0]DRAM_dataOut,                             // from DR
    output [WIDTH-1:0]IROM_addr,                                // PC
    output [WIDTH-1:0]DRAM_addr,                                // AR
    output wire memREAD, memWRITE, iROMREAD, coreS, nextLoop
);

wire [15:0] wEN;
wire [6:0] INC;
wire [5:0] RST;
wire [2:0] compMUX;
wire [3:0] aluOP;
wire zFlag;
wire selAR;
wire [4:0]busMUX;
wire coreINC_AR;

wire [WIDTH-1:0]INS;                                            // instruction from iROM
wire [WIDTH-1:0] COMP_IN1;
wire [WIDTH-1:0] COMP_IN2;
wire [WIDTH-1:0]PC_OUT;
wire [WIDTH-1:0]AR_OUT;
wire [WIDTH-1:0]DR_OUT;
wire [WIDTH-1:0]RP_OUT;
wire [WIDTH-1:0]RT_OUT;
wire [WIDTH-1:0]RT4_OUT;
wire [WIDTH-1:0]RR_OUT;
wire [WIDTH-1:0]RM1_OUT;
wire [WIDTH-1:0]RL1_OUT; //////////////////////
wire [WIDTH-1:0]RK1_OUT;
wire [WIDTH-1:0]RN1_OUT;
wire [WIDTH-1:0]RM2_OUT;
wire [WIDTH-1:0]RK2_OUT;
wire [WIDTH-1:0]RN2_OUT;
wire [WIDTH-1:0]RL2_OUT; /////////////////////
wire [WIDTH-1:0]C1_OUT;
wire [WIDTH-1:0]C2_OUT;
wire [WIDTH-1:0]C3_OUT;
wire [WIDTH-1:0]AC_OUT;
wire [WIDTH-1:0]ALU_OUT;
wire [WIDTH-1:0]BUSMUX_OUT;
//PC                                                    15                 5
PC #(.WIDTH(WIDTH)) PC (.Clk(Clk), .WEN(wEN[`PC_W]), .INC(INC[`PC_INC]), .BusOut(AR_OUT), .dout(PC_OUT));
//IR                                                    14
Reg_module_W #(.WIDTH(WIDTH)) IR (.Clk(Clk), .WEN(wEN[`IR_W]), .BusOut(IROM_dataIn), .dout(INS));
//AR                                          13
AR #(.WIDTH(WIDTH)) AR (.Clk(Clk), .WEN(wEN[`AR_W]), .BusOut(BUSMUX_OUT), .IOut(IROM_dataIn), .selAR(selAR), .dout(AR_OUT), .coreID(coreID), .coreINC_AR(coreINC_AR));
//DR                                                    12
Reg_module_W #(.WIDTH(WIDTH)) DR (.Clk(Clk), .WEN(wEN[`DR_W]), .BusOut(BUSMUX_OUT), .dout(DR_OUT));
//RP                                                    11
Reg_module_W #(.WIDTH(WIDTH)) RP (.Clk(Clk), .WEN(wEN[`RP_W]), .BusOut(BUSMUX_OUT), .dout(RP_OUT));
//RT                                                    10
Reg_module_RW #(.WIDTH(WIDTH)) RT (.Clk(Clk), .WEN(wEN[`RT_W]), .RST(RST[`RT_RST]), .BusOut(BUSMUX_OUT), .dout(RT_OUT));   
//RT4                                                   16
Reg_module_W #(.WIDTH(WIDTH)) RT4 (.Clk(Clk), .WEN(wEN[`RT4_W]), .BusOut(BUSMUX_OUT), .dout(RT4_OUT));
//Rr                                                   16
Reg_module_W #(.WIDTH(WIDTH)) RR (.Clk(Clk), .WEN(wEN[`RR_W]), .BusOut(BUSMUX_OUT), .dout(RR_OUT));
//RM1                                                   9
Reg_module_W #(.WIDTH(WIDTH)) RM1 (.Clk(Clk), .WEN(wEN[`RM1_W]), .BusOut(BUSMUX_OUT), .dout(RM1_OUT));
//RK1                                                   8
Reg_module_W #(.WIDTH(WIDTH)) RK1 (.Clk(Clk), .WEN(wEN[`RK1_W]), .BusOut(BUSMUX_OUT), .dout(RK1_OUT));
//RN1                                                   7
Reg_module_W #(.WIDTH(WIDTH)) RN1 (.Clk(Clk), .WEN(wEN[`RN1_W]), .BusOut(BUSMUX_OUT), .dout(RN1_OUT));
///////////////////////////////////////////////////////////
//RL1                                                   9
Reg_module_W #(.WIDTH(WIDTH)) RL1 (.Clk(Clk), .WEN(wEN[`RL1_W]), .BusOut(BUSMUX_OUT), .dout(RL1_OUT));
//RL2
Reg_module_RI #(.WIDTH(WIDTH)) RM2 (.Clk(Clk), .RST(RST[`RL2_RST]), .INC(INC[`RL2_INC]), .BusOut(BUSMUX_OUT), .dout(RL2_OUT));
////////////////////////////////////////////////////////////

//RM2
Reg_module_RI #(.WIDTH(WIDTH)) RL2 (.Clk(Clk), .RST(RST[`RM2_RST]), .INC(INC[`RM2_INC]), .BusOut(BUSMUX_OUT), .dout(RM2_OUT));
//RK2
Reg_module_RI #(.WIDTH(WIDTH)) RK2 (.Clk(Clk), .RST(RST[`RK2_RST]), .INC(INC[`RK2_INC]), .BusOut(BUSMUX_OUT), .dout(RK2_OUT));
//RN2
Reg_module_RI #(.WIDTH(WIDTH)) RN2 (.Clk(Clk), .RST(RST[`RN2_RST]), .INC(INC[`RN2_INC]), .BusOut(BUSMUX_OUT), .dout(RN2_OUT));
//RC1                                                   3
Reg_module_W #(.WIDTH(WIDTH)) RC1 (.Clk(Clk), .WEN(wEN[`RC1_W]), .BusOut(BUSMUX_OUT), .dout(C1_OUT));
//RC2                                                   2                   1
Reg_module_WI #(.WIDTH(WIDTH)) RC2 (.Clk(Clk), .WEN(wEN[`RC2_W]), .INC(INC[`RC2_INC]), .BusOut(BUSMUX_OUT), .dout(C2_OUT));
//RC3                                                   1                   0
Reg_module_WI #(.WIDTH(WIDTH)) RC3 (.Clk(Clk), .WEN(wEN[`RC3_W]), .INC(INC[`RC3_INC]), .BusOut(BUSMUX_OUT), .dout(C3_OUT));
//AC                                                     0
Reg_module_RW #(.WIDTH(WIDTH)) AC (.Clk(Clk), .WEN(wEN[`AC_W]), .RST(RST[`AC_RST]), .BusOut(ALU_OUT), .dout(AC_OUT));   

//ALU
Alu #(.WIDTH(WIDTH)) ALU (.AC(AC_OUT), .BusOut(BUSMUX_OUT), .result_ac(ALU_OUT), .ALU_OP(aluOP), .MEM_ID(MEM_ID));

mux_3to1_8bit  COMPMUX1 (.mux_inN(RN1_OUT), .mux_inK(RK1_OUT), .mux_inM(RM1_OUT), .mux_sel(compMUX), .mux_out(COMP_IN1));
mux_3to1_8bit  COMPMUX2 (.mux_inN(RN2_OUT), .mux_inK(RK2_OUT), .mux_inM(RM2_OUT), .mux_sel(compMUX), .mux_out(COMP_IN2));
Comp #(.WIDTH(WIDTH)) COMP (.R1(COMP_IN1), .R2(COMP_IN2), .z(zFlag));

Bus_mux #(.WIDTH(WIDTH)) BUSMUX(.MEM(DRAM_dataIn), .AR(AR_OUT), .DR(DR_OUT), .RP(RP_OUT), .RT(RT_OUT), .RM1(RM1_OUT), .RK1(RK1_OUT), .RN1(RN1_OUT), .RM2(RM2_OUT), .RK2(RK2_OUT), .RN2(RN2_OUT), .C1(C1_OUT), .C2(C2_OUT), .C3(C3_OUT), .AC(AC_OUT), .mux_sel(busMUX), .Bus_select(BUSMUX_OUT), .RR(RR_OUT), .RT4(RT4_OUT), .RL1(RL1_OUT), .RL2(RL2_OUT));
//CU
controlunit #(.WIDTH(WIDTH)) CU (.Clk(Clk), .z(zFlag), .INS(INS), .iROMREAD(iROMREAD), .memREAD(memREAD), .memWRITE(memWRITE), .wEN(wEN), .selAR(selAR), .busMUX(busMUX), .INC(INC), .RST(RST), .compMUX(compMUX), .aluOP(aluOP), .coreS(coreS), .memAV(memAV), .imemAV(imemAV), .coreINC_AR(coreINC_AR), .nextLoop(nextLoop));


assign IROM_addr = PC_OUT;
assign DRAM_dataOut = DR_OUT;
assign DRAM_addr = AR_OUT;
endmodule