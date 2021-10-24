module PC //write, increment enable /PC, C2, C3
#(parameter WIDTH = 8)
(Clk, WEN,INC,BusOut,dout);
input Clk, WEN,INC;
input [WIDTH-1:0] BusOut;
output [WIDTH-1:0] dout;
reg [WIDTH-1:0] value;

initial begin
    value <= 8'b0;
end
always @(negedge Clk) 
begin

    if (WEN) value <= BusOut;
    else if (INC) value <= dout + 8'b1;       
end

assign dout=value;
    
endmodule