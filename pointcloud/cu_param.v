//DEFINE OPERATIONS
`define NO_OP 4'h0
`define JMP 4'h1
`define COPY 4'h2
`define LOAD 4'h3
`define STORE 4'h4
`define ASSIGN 4'h5
`define RESET 4'h6
`define MOVE 4'h7
`define SET 4'h8
`define MUL 4'h9
`define ADD 4'hA
`define INC 4'hB
`define END 4'hC
`define CHK_IDLE 4'hD
`define GET_C1 4'hE

//JMP PARAM
`define JMP_M 4'h0
`define JMP_K 4'h1
`define JMP_N 4'h2
`define JMP_L 4'h3

//COPY PARAM 
`define COPY_M 4'h0
`define COPY_K 4'h1
`define COPY_N 4'h2
`define COPY_R 4'h3
`define COPY_T 4'h4
`define COPY_L 4'h5

//LOAD PARAM
`define LOAD_C1 4'h0
`define LOAD_C2 4'h1

//ASSIGN PARAM  !!!!not needed for CU
`define ASSIGN_C1 4'h0
`define ASSIGN_C2 4'h1
`define ASSIGN_C3 4'h2

//RESET PARAM
`define RESET_ALL 4'h0
`define RESET_N2 4'h1
`define RESET_K2 4'h2
`define RESET_Rt 4'h3

//MOVE PARAM
`define MOVE_RP 4'h0
`define MOVE_RT 4'h1
`define MOVE_RC1 4'h2
`define MOVE_C3 4'h3

//SET PARAM
`define SETC1 4'h0
`define SETDR 4'h1
`define SETRK1 4'h2
//ADD PARAM 
`define ADD_RT  4'h0
`define ADD_RR1  4'h1
`define ADD_RM2 4'h2
`define ADD_MEM 4'h3
//INC PARAM
`define INC_C2 4'h0
`define INC_C3 4'h1
`define INC_M2 4'h2
`define INC_K2 4'h3
`define INC_N2 4'h4
`define INC_L2 4'h5

//MUL PARAM
`define MUL_RP 4'h0
//`define MUL_CORE 4'hF

//////////      STATES      //////////

`define NOOP_1 8'h00

`define FETCH_1 8'h10
`define FETCH_2 8'h11
`define FETCH_3 8'h12

`define JMPM_1 8'h20
`define JMPK_1 8'h21
`define JMPN_1 8'h22
`define JMPL_1 8'h26
`define JMP_2 8'h23
`define JMP_3 8'h24
`define JMP_4 8'h25

`define ZJMP_1 8'h30
`define NJMP_1 8'h31

`define COPY_1 8'h40
`define COPY_2 8'h41
`define COPY_3 8'h42
`define COPY_4 8'h43
`define COPYM_5 8'h44
`define COPYK_5 8'h45
`define COPYN_5 8'h46
`define COPYM_3A 8'h47
`define COPYR_5 8'h48
`define COPYRT4_5 8'h49
`define COPYRL_5 8'h4A

`define LOAD_2 8'h50
`define LOAD_3 8'h51
`define LOADC1_1 8'h52
`define LOADC2_1 8'h53
`define LOADC1_3 8'h54
`define LOADC2_3 8'h55

`define STORE_1 8'h60
`define STORE_2 8'h61
`define STORE_3 8'h62

`define ASSIGN_1 8'h70
`define ASSIGN_2 8'h71
`define ASSIGNC1_3 8'h72
`define ASSIGNC2_3 8'h73
`define ASSIGNC3_3 8'h74
`define ASSIGNC1_3A 8'h75


`define RESETALL_1 8'h80
`define RESETN2_1 8'h81
`define RESETK2_1 8'h82
`define RESETRt_1 8'h83

`define MOVEP_1 8'h90
`define MOVET_1 8'h91
`define MOVEC1_1 8'h92
`define MOVEC3_1 8'h93

`define SETC1_1 8'hA0
`define SETDR_1 8'hA1
`define SETRK1_1 8'hA2

`define MULRP_1 8'hB0
`define MULCORE_1 8'hBF

`define ADDRT_1 8'hC0
`define ADDRR1_1 8'hC1
`define ADDRM2_1 8'hC2
`define ADDC3_1 8'hC3

`define INCC2_1 8'hD0
`define INCC3_1 8'hD1
`define INCM2_1 8'hD2
`define INCK2_1 8'hD3
`define INCN2_1 8'hD4
`define INCL2_1 8'hD5

`define ENDOP_1 8'hE0

`define HOLD_1 8'hF0
`define CHKIDLE_1 8'hF1
`define CHKIDLE_2 8'hF2
`define GETC1_1 8'hF3

