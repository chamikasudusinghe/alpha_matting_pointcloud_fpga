module Reg_module_W //write enable /IR, AR, Rp, Rt, Rk1, Rm1, Rn1, C1
#(parameter WIDTH = 8)
(Clk, WEN, BusOut, dout);
input Clk, WEN;
input [WIDTH-1:0] BusOut;
output [WIDTH-1:0] dout;
reg [WIDTH-1:0] value;

always @(negedge Clk) 
begin

    if (WEN) value <= BusOut;
          
end

assign dout=value;
    
endmodule