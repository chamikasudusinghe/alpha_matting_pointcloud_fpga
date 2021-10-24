module Reg_module_RI //increment, reset enable //Rn2, Rk2, Rm2
#(parameter WIDTH = 8)
(Clk, RST,INC,BusOut,dout);
input Clk, RST,INC;
input [WIDTH-1:0] BusOut;
output [WIDTH-1:0] dout;
reg [WIDTH-1:0] value;

always @(negedge Clk) 
begin

    if (RST) value <= 8'b0;
    else if (INC) value <= dout + 8'b1;       
end

assign dout=value;
    
endmodule