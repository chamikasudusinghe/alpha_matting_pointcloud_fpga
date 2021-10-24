module Reg_module_RW //write, reset enable //Rt, AC
#(parameter WIDTH = 8)
(Clk,RST,WEN,BusOut,dout);
input Clk, WEN,RST;
input [WIDTH-1:0] BusOut;
output [WIDTH-1:0] dout;
reg [WIDTH-1:0] value;


always @(negedge Clk) 
begin

    if (WEN) value <= BusOut;
    else if (RST) value <= 8'b0;       
end

assign dout=value;
    
endmodule