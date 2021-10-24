//`include "proc_pram.v"
//  MEM AR  DR  RP  RT  RM1 RK1 RN1 RM2 RK2 RN2 C1  C2  C3  AC
//  15   14  13  12  11  10  9   8   7   6   5   4   3   2   1   

module Bus_mux
#(parameter WIDTH = 8)
(MEM, AR, DR, RP, RT, RM1, RK1, RN1, RM2, RK2, RN2, C1,  C2,  C3,  AC, RR, RT4, RL1, RL2, mux_sel, Bus_select);

input [4:0] mux_sel;
input [WIDTH-1:0] MEM, AR, DR, RP, RT, RM1, RK1, RN1, RM2, RK2, RN2, C1,  C2,  C3,  AC, RR, RT4, RL1, RL2;
output [WIDTH-1:0] Bus_select;
// The output is defined as register 
reg [WIDTH-1:0] select;
always @(*)
begin
    case(mux_sel)
        
        5'b00001:
            select <= AC;
        5'b00010:
            select <= C3;
        5'b00011: 
            select <= C2;
        5'b00100:
            select <= C1;
        5'b00101:
            select <= RN2;
        5'b00110:
            select <= RK2;
        5'b00111:
            select <= RM2;
        5'b01000:
            select <= RN1;
        5'b01001:
            select <= RK1;
        5'b01010:
            select <= RM1;
        5'b01011:
            select <= RT;
        5'b01100:
            select <= RP;
        5'b01101:
            select <= DR;
        5'b01110:
            select <= AR;
        5'b01111:
            select <= MEM;
        5'b10000:
            select <= RR;
        5'b10001:
            select <= RT4;
        5'b10010:
            select <= RL1;   
        5'b10011:
            select <= RL2;         
        default: select <= 8'bz;
    endcase   
end 

assign Bus_select = select;
endmodule
