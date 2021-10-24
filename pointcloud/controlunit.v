`include "cu_param.v"

//Control unit outputs
// iROMREAD
// memREAD             //AR read, memory read, DR write
// memWRITE

// [15:0]wEN
//REGISTERS: 
//  RL   RT4  Rr  PC  IR  AR  DR  RP  RT  RM1 RK1 RN1 C1  C2  C3  AC
//  15   14   13  12 _11  10  9   8  _7   6   5   4  _3   2   1   0


// [4:0]busMUX		(2**4)
//RL   RT4    Rr  MEM   AR  DR  RP  RT  RM1 RK1 RN1 RM2 RK2 RN2 C1  C2  C3  AC
//18   17     16   15   14	13  12  11  10  9   8   7   6   5   4   3   2   1   


// [5:0]INC        
//  PC  RM2 RK2 RN2  C2  C3
//  5   4   3   2   1   0

// [4:0] RST
// RT   RM2    RK2    RN2   AC
// 4    3      2      1     0

// [2:0]compMUX              //both muxes get the same control signal
// L1-L2     M1-M2   K1-K2    N1-N2
//   3          2       1        0

// [3:0]aluOP
// ADDMEM  ADD      MUL     SET     
// 3        2        1       0


//NEXT INSTRUCTION

module controlunit 
#(parameter WIDTH = 8)
(
    input Clk,
    input z,                                //JUMP flag
    input [WIDTH-1:0] INS,                  //Instruction from the Instruction memory
    input memAV,                             //DATA MEMORY AVAILABLE flag
    input imemAV,                           //INSTRUCTION MEMORY AVAILABLE flag
    output reg iROMREAD,                    //rEn of IROM
    output reg memREAD, nextLoop,                     //rEN of DRAM
    output reg memWRITE,                    //wEN of DRAM
    output reg [15:0] wEN,                  //wEN bitmask of core registers
    output reg selAR,                       //flag to be used in address fetching to AR from IROM
    output reg coreINC_AR,                  //flag to be used in increament the addresses by the coreID
    output reg [4:0] busMUX,                //Bus selector
    output reg [6:0] INC,                   //Register increment bitmask
	output reg [5:0] RST,                   //Register reset bitmask
    output reg [2:0] compMUX,               //Control signal to the comparator
    output reg [3:0] aluOP,                 //Control signal to the ALU 
    output reg coreS                        //Core state flag
);


reg [7:0]NEXT_STATE=`FETCH_1;
reg [7:0]STATE=`FETCH_1;
reg zFlag, memAVREG, jmpMFlag;

always @(negedge Clk) begin
    zFlag = z;
    memAVREG = memAV;
end


//DEFINE ALL THE STATES OF THE CONTROL UNIT
always @(posedge Clk) begin
    STATE = NEXT_STATE;
    case(STATE) 
        // `NOOP_1 : begin                             //NO_OP
        //     memREAD <= 0;              
        //     memWRITE <= 0;
        //     wEN <= 0;
        //     selAR <= 0;
        //     coreINC_AR <= 0; 
        //     busMUX <= 0;
        //     INC <= 0;
        //     RST <= 0;
        //     compMUX <= 0;
        //     aluOP <= 0;
        //     coreS <= 0;
        //     NEXT_STATE <= `FETCH_1;
        //     iROMREAD <= 1;                          //iROM read before FETCH_1
        // end
        `FETCH_1 : begin                            //FETCH_1     iROM[PC]
            iROMREAD <= 1;       
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            if (imemAV) begin                       //Wait unitl instruction is available to the CU
                NEXT_STATE <= `FETCH_2;
            end
            else begin
                NEXT_STATE <= `FETCH_1;
            end    
        end
        `FETCH_2 : begin                            //FETCH_2     IR <= iROM[PC], PC <= PC+1
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_1000_0000_0000;         //IR WRITE
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 0;
            INC <= 7'b010_0000;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `FETCH_3;
        end
        `FETCH_3 : begin                            //FETCH_3      IR HAS ALREADY GOT THE INS
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;         
            busMUX <= 0;
            INC <= 0; 
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            case (INS[7:4])
                `JMP : begin
                    case (INS[3:0])
                        `JMP_M : NEXT_STATE <= `JMPM_1;
                        `JMP_K : NEXT_STATE <= `JMPK_1;
                        `JMP_N : NEXT_STATE <= `JMPN_1;
                        `JMP_L : NEXT_STATE <= `JMPL_1; 
                    endcase
                end
                `COPY : begin
                    NEXT_STATE <= `COPY_1;
                    iROMREAD <= 1;
                end
                `LOAD : begin
                    case (INS[3:0])
                       `LOAD_C1 : NEXT_STATE <= `LOADC1_1;
                       `LOAD_C2 : NEXT_STATE <= `LOADC2_1;
                    endcase
                end
                `STORE : NEXT_STATE <= `STORE_1;
                `ASSIGN : begin
                    NEXT_STATE <= `ASSIGN_1;
                    iROMREAD <= 1;                                  //iROM read before ASSIGN_1
                end
                `RESET : begin
                    case (INS[3:0])
                        `RESET_ALL : NEXT_STATE <= `RESETALL_1;
                        `RESET_N2 : NEXT_STATE <= `RESETN2_1;
                        `RESET_K2 : NEXT_STATE <= `RESETK2_1;
                        `RESET_Rt : NEXT_STATE <= `RESETRt_1;
                    endcase
                end
                `MOVE : begin
                    case (INS[3:0])
                        `MOVE_RP : NEXT_STATE <= `MOVEP_1;
                        `MOVE_RT : NEXT_STATE <= `MOVET_1;
                        `MOVE_RC1 : NEXT_STATE <= `MOVEC1_1;
                        `MOVE_C3 : NEXT_STATE <= `MOVEC3_1;
                    endcase
                end
                `SET : begin
                    case (INS[3:0])
                        `SETC1 : NEXT_STATE <= `SETC1_1;
                        `SETDR : NEXT_STATE <= `SETDR_1;
                        //`SETRK1 : NEXT_STATE <= `SETRK1_1;
                    endcase
                end
                `MUL : begin
                    case (INS[3:0])
                    `MUL_RP : NEXT_STATE <= `MULRP_1;
                    //`MUL_CORE : NEXT_STATE <= `MULCORE_1;
						  endcase
                end
                `ADD : begin
                    case (INS[3:0])
                        `ADD_RT : NEXT_STATE <= `ADDRT_1;
                        `ADD_RR1 : NEXT_STATE <= `ADDRR1_1;
                        `ADD_RM2 : NEXT_STATE <= `ADDRM2_1;
                        `ADD_MEM : NEXT_STATE <= `ADDC3_1;
                    endcase
                end
                `INC : begin
                    case (INS[3:0])
                        `INC_C2 : NEXT_STATE <= `INCC2_1;
                        `INC_C3 : NEXT_STATE <= `INCC3_1;
                        `INC_M2 : NEXT_STATE <= `INCM2_1;
                        `INC_K2 : NEXT_STATE <= `INCK2_1;
                        `INC_N2 : NEXT_STATE <= `INCN2_1;
                        `INC_L2 : NEXT_STATE <= `INCL2_1;
                    endcase
                end
                `END : NEXT_STATE <= `ENDOP_1;
                `CHK_IDLE : NEXT_STATE <= `CHKIDLE_1;
                `GET_C1 : NEXT_STATE <= `GETC1_1;                             
            endcase
        end
        
        `JMPM_1 : begin                                     //`JMPM_1                     REG M1 - REG M2
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 3'b100;
            aluOP <= 0;
            coreS <= 0;
            jmpMFlag <= 1;                                  //to check end operation in ZJMP
            NEXT_STATE <= `ZJMP_1;  
        end
        `JMPK_1 : begin                                     //JMP_K                     REG K1 - REG K2
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 3'b010;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `ZJMP_1;
        end
        `JMPN_1 : begin                                     //JMP_N                     REG N1 - REG N2
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 3'b001;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `ZJMP_1;
        end
        `JMPL_1 : begin                                     //JMP_N                     REG N1 - REG N2
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 3'b011;
            aluOP <= 0;
            coreS <= 0;
            nextLoop <= 1;
            jmpMFlag <= 1;
            NEXT_STATE <= `ZJMP_1;
        end

        `ZJMP_1 : begin                                     //ZERO CHECK (check loop termination)
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            nextLoop <= 0;
            if (zFlag == 1 && jmpMFlag == 1) begin          //end of the program
                NEXT_STATE <= `ENDOP_1;
                jmpMFlag <= 0;
                coreS <= 1;
            end
            else if (zFlag == 1 && jmpMFlag == 0) begin
                NEXT_STATE <= `NJMP_1;
            end  
            else begin
                NEXT_STATE <= `JMP_2;
                iROMREAD <= 1;                              // iROM read before JMP_2
                jmpMFlag <= 0;
            end
        end
       `JMP_2 : begin                                       //JMP_2                 READ_IROM[PC]
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <=`JMP_3;
        end
       `JMP_3 :begin                                        //JMP_3                  AR <= IROM[PC]
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0100_0000_0000;     
            selAR <= 1;
            coreINC_AR <= 0; 
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <=`JMP_4;
        end
       `JMP_4 : begin                                       //JMP_4                 PC <= AR
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0001_0000_0000_0000;
            selAR <= 0;
            busMUX <= 14;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
        end
        `NJMP_1 : begin                                     //NO`JMP                 PC <= PC + 1
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 0;
            INC <= 7'b010_0000;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
        end
        `COPY_1 : begin                                     //`COPY_1                READ_IROM[PC]
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `COPY_2;
        end 
        `COPY_2 : begin                                     //`COPY_2                AR <= IROM[PC], PC <= PC + 1
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0100_0000_0000; 
            selAR <= 1;
            coreINC_AR <= 0; 
            busMUX <= 0;
            INC <= 7'b010_0000;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            if (INS[3:0]== `COPY_M || INS[3:0]== `COPY_T) begin             
                NEXT_STATE <= `COPYM_3A;
            end
            else begin
                NEXT_STATE <= `COPY_3;
            end
        end
        `COPYM_3A : begin                                   //COPYM3_A                 AR <= AR + Core_ID    
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            coreINC_AR <= 1; 
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `COPY_3;
        end 
        `COPY_3 : begin                                     //`COPY_3              MEM_READ[AR]  ... GIVING MEMORY ADDRESS
            iROMREAD <= 0;
            memREAD <= 1;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 4'b1111;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            if (memAVREG) begin
                NEXT_STATE <= `COPY_4;
            end
            else begin
                NEXT_STATE <= `HOLD_1;
            end
        end
        `COPY_4 : begin                                     //`COPY_4            DR <= MEM_READ[AR] ... ALREADY RECEIVED DATA
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0010_0000_0000;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 4'b1111;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            if (INS[3:0]== `COPY_M) begin               // RM1            
                NEXT_STATE <= `COPYM_5;
            end
            else if (INS[3:0]== `COPY_K) begin          // RK1
                NEXT_STATE <= `COPYK_5;
            end
            else if (INS[3:0]== `COPY_N) begin          // RN1
                NEXT_STATE <= `COPYN_5;
            end
            else if (INS[3:0]== `COPY_R) begin          // Rr
                NEXT_STATE <= `COPYR_5;
            end
            else if (INS[3:0]== `COPY_T) begin          // RT4 
                NEXT_STATE <= `COPYRT4_5;
            end
            else if (INS[3:0]== `COPY_L) begin          // RT4 
                NEXT_STATE <= `COPYRL_5;
            end
        end
        `COPYM_5 : begin                                //`COPY M1               REG M1 <= DR
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0000_0100_0000;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 4'b1101;       
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        `COPYK_5 : begin                                //`COPY K1               REG K1 <= DR
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0000_0010_0000;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 4'b1101;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        `COPYN_5 : begin                                //`COPY N1               REG N1 <= DR
            memREAD <= 1;              
            memWRITE <= 0;
            wEN <= 16'b0000_0000_0001_0000;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 13;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        `COPYR_5 : begin                                //`COPY Rr               Rr <= DR
            memREAD <= 1;              
            memWRITE <= 0;
            wEN <= 16'b0010_0000_0000_0000;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 13;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        `COPYRT4_5 : begin                              //`COPY RT4               RT4 <= DR
            memREAD <= 1;              
            memWRITE <= 0;
            wEN <= 16'b0100_0000_0000_0000;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 13;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        `COPYRL_5 : begin                              //`COPY RT4               RT4 <= DR
            memREAD <= 1;              
            memWRITE <= 0;
            wEN <= 16'b1000_0000_0000_0000;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 13;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        `LOAD_2 : begin                                 //`LOAD_2                    MEM_READ[AR]
            iROMREAD <= 0;
            memREAD <= 1;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 15;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            if (memAVREG) begin
                case (INS[3:0])
                    `LOAD_C1: NEXT_STATE <= `LOADC1_3;
                    `LOAD_C2: NEXT_STATE <= `LOADC2_3;
                    default: NEXT_STATE <= `LOAD_3;
                endcase
            end
            else begin
                NEXT_STATE <= `HOLD_1;
            end
        end
        `LOADC1_3 : begin                                 //`LOAD_3                    RP <= MEM_READ[AR]
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0001_0000_0000;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 15;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        `LOADC2_3 : begin                                 //`LOAD_3                    AC <= MEM_READ[AR]
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0000_0000_0001;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 15;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 4'b0001;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        `LOAD_3 : begin                                 //`LOAD_3                    DR <= MEM_READ[AR]
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0010_0000_0000;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 15;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        `LOADC1_1 : begin                               //`LOAD_C1                   AR <= C1
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0100_0000_0000;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 4;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `LOAD_2;
        end
        `LOADC2_1 : begin                               //`LOAD_C2                    AR <= C2
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0100_0000_0000;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 3;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `LOAD_2;
        end
        `STORE_1 : begin                                //`STORE_1                    DR <= RT
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0010_0000_0000;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 11;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `STORE_2;
        end
        `STORE_2 : begin                                //`STORE_2                      AR <= C3
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0100_0000_0000;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 2;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `STORE_3;
        end
        `STORE_3 : begin                                //`STORE_3                   MEM_WRITE[AR] <= DR
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 1;
            wEN <= 0;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 13;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1; 
            iROMREAD <= 1; 
            // if (memAVREG) begin
            //     NEXT_STATE <= `FETCH_1; 
            //     iROMREAD <= 1;                          // iROM read before FETCH_1
            // end
            // else begin
            //     NEXT_STATE <= `HOLD_1;                  // Hold the processor till the DRAM gives data
            // end
        end
        `ASSIGN_1 : begin                               //ASSIGN_1                   READ_IROM[PC]
            iROMREAD <= 0;    
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `ASSIGN_2;
        end
        `ASSIGN_2 : begin                               //ASSIGN_3                AR <= IROM[PC], PC <= PC+1
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0100_0000_0000;
            selAR <= 1;
            coreINC_AR <= 0; 
            busMUX <= 0;
            INC <= 7'b010_0000;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            if (INS[3:0]== `ASSIGN_C1) begin             
                NEXT_STATE <= `ASSIGNC1_3A;
            end
            else if (INS[3:0]== `ASSIGN_C2) begin             
                NEXT_STATE <= `ASSIGNC2_3;
            end
            // else if (INS[3:0]== `ASSIGN_C3) begin             //not needed in new algo
            //     NEXT_STATE <= `ASSIGNC3_3;
			// 	end
        end 
        `ASSIGNC1_3A : begin                            //ASSIGN_C1A                  AR <= AR + Core_ID
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0000_0000_1000;
            selAR <= 0;
            coreINC_AR <= 1; 
            busMUX <= 14;                               
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `ASSIGNC1_3;
		end 
	    `ASSIGNC1_3 : begin                             //ASSIGN_C1                   C1 <= AR
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0000_0000_1000;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 14;                               
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
		end 
		`ASSIGNC2_3 : begin                             //ASSIGN_C2                   C2 <= AR
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0000_0000_0100;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 14;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        // `ASSIGNC3_3 : begin             //ASSIGN_C3                   C3 <= AR     //not needed in new algo
        //     iROMREAD <= 0;
        //     memREAD <= 0;              
        //     memWRITE <= 0;
        //     wEN <= 16'b0000_0000_0000_0010;
        //     selAR <= 0;
        //     coreINC_AR <= 0; 
        //     busMUX <= 14;
        //     INC <= 0;
        //     RST <= 0;
        //     compMUX <= 0;
        //     aluOP <= 0;
        //     coreS <= 0;
        //     NEXT_STATE <= `FETCH_1;
        //     iROMREAD <= 1;           // iROM read before FETCH_1
        // end
        `RESETALL_1 : begin                             //RESET_ALL 
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 0;
            INC <= 0;
            RST <= 6'b111111;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        `RESETN2_1 : begin                              //RESET REG N2
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 0;
            INC <= 0;
            RST <= 6'b000010;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        `RESETK2_1 : begin                              //RESET REG K2
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 0;
            INC <= 0;
            RST <= 6'b000100;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        `RESETRt_1 : begin                              //RESET REG RT
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 0;
            INC <= 0;
            RST <= 6'b010000;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        `MOVEP_1 : begin                                //MOVE TO REG P               REG P <= AC
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0001_0000_0000;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 1;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        `MOVET_1 : begin                                //MOVE TO REG T             REG T <= AC
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0000_1000_0000;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 1;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        `MOVEC1_1 : begin                               //MOVE TO REG C1                C1 <= AC
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0000_0000_1000;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 1;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        `MOVEC3_1 : begin                               //MOVE TO REG C3                C3 <= AC
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0000_0000_0010;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 1;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        `SETC1_1 : begin                                //SET AC AS C1               SET, AC <= C1
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0000_0000_0001;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 4;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 4'b0001;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        `SETDR_1 : begin                                //SET AC AS DR                SET, AC <= DR
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0000_0000_0001;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 13;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 4'b0001;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        // `SETRK1_1 : begin       //SET AC AS DR                SET, AC <= DR
        //     iROMREAD <= 0;
        //     memREAD <= 0;              
        //     memWRITE <= 0;
        //     wEN <= 16'b0000_0000_0000_0001;
        //     selAR <= 0;
        //     coreINC_AR <= 0; 
        //     busMUX <= 9;
        //     INC <= 0;
        //     RST <= 0;
        //     compMUX <= 0;
        //     aluOP <= 4'b0001;
        //     coreS <= 0;
        //     NEXT_STATE <= `FETCH_1;
        // end
        `MULRP_1 : begin                                //MUL REG P                 AC <= REG_P * AC
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0000_0000_0001;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 12;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 4'b0010;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        // `MULCORE_1 : begin       //AC MULTIPLY CORE ID               AC <= CORE ID * AC
        //     iROMREAD <= 0;
        //     memREAD <= 0;              
        //     memWRITE <= 0;
        //     wEN <= 16'b0000_0000_0000_0001;
        //     selAR <= 0;
        //     coreINC_AR <= 0; 
        //     busMUX <= 0;
        //     INC <= 0;
        //     RST <= 0;
        //     compMUX <= 0;
        //     aluOP <= 4'b1000;
        //     coreS <= 0;
        //     NEXT_STATE <= `FETCH_1;
        // end

        `ADDRT_1 : begin                                //ADD REG_T                AC <= REG_1 + AC
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0000_0000_0001;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 11;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 4'b0100;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        `ADDRR1_1 : begin                               //ADD REG_Rr                AC <= Rr + AC
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0000_0000_0001;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 16;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 4'b0100;   
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        `ADDRM2_1 : begin                               //ADD REG_M2                AC <= REG_M2 + AC
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0000_0000_0001;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 7;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 4'b0100;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        `ADDC3_1 : begin                                //ADD RK1*CORE_ID TO C3                AC <= C3 + AC
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0000_0000_0001;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 2;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 4'b1000;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        `INCC2_1 : begin                                //INC REG C2               REG C2 <= C2+1
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            busMUX <= 0;
            INC <= 7'b000_0010;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        `INCC3_1 : begin                                //INC REG C3                REG C3 <= C3+1
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 0;
            INC <= 7'b000_0001;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        `INCM2_1 : begin                                //INC reg m2                REG M2 <= M2+1
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 0;
            INC <= 7'b001_0000;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        `INCK2_1 : begin                                //INC REG K2               REG K2 <= K2+1
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 0;
            INC <= 7'b000_1000;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        `INCN2_1 : begin                                //INC REG N2               REG N2 <= N2+1
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 0;
            INC <= 7'b000_0100;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        `INCL2_1 : begin                                //INC REG N2               REG N2 <= N2+1
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 0;
            INC <= 7'b100_0000;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                              // iROM read before FETCH_1
        end
        `ENDOP_1 : begin                                //INC REG N2               REG N2 <= N2+1
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 1;
            NEXT_STATE <= `ENDOP_1;
        end
        `HOLD_1 : begin
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            coreS <= 0;
            if (memAVREG) begin
                case (INS[7:4])
                    `COPY : NEXT_STATE <= `COPY_4;
                    `LOAD : begin
                        case (INS[3:0])
                            `LOAD_C1: NEXT_STATE <= `LOADC1_3;
                            `LOAD_C2: NEXT_STATE <= `LOADC2_3;
                            default: NEXT_STATE <= `LOAD_3;
                        endcase
                    end 
                    `STORE : begin
                        NEXT_STATE <= `FETCH_1;
                        iROMREAD <= 1;                      // iROM read before FETCH_1
                    end
                endcase
            end
            else begin
                NEXT_STATE <= `HOLD_1;                      // Hold till data is available frome DRAM
            end
        end
        `CHKIDLE_1 : begin                                  //CHECK RM1 - RM2                    REG M1 - REG M2
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 3'b100;
            aluOP <= 0;
            coreS <= 0;
            NEXT_STATE <= `CHKIDLE_2;
        end
        `CHKIDLE_2 : begin      //ZERO CHECK
            iROMREAD <= 0;
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 0;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 0;
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 0;
            if (zFlag) begin
                NEXT_STATE <= `ENDOP_1;
            end  
            else begin
                NEXT_STATE <= `FETCH_1;
                iROMREAD <= 1;                              // iROM read before FETCH_1
            end
        end
        `GETC1_1 : begin                                    //MOVE RT4 VAL TO REG C1                C1 <= RT4
            memREAD <= 0;              
            memWRITE <= 0;
            wEN <= 16'b0000_0000_0000_0001;
            selAR <= 0;
            coreINC_AR <= 0; 
            busMUX <= 17;  //RT4
            INC <= 0;
            RST <= 0;
            compMUX <= 0;
            aluOP <= 4'b0001;
            coreS <= 0;
            NEXT_STATE <= `FETCH_1;
            iROMREAD <= 1;                                  // iROM read before FETCH_1
        end
    endcase     
end
endmodule

