module Comp 
#(parameter WIDTH = 8) 
(
    input [WIDTH-1:0] R1, R2,               //inputs comes from AC and bus
    output wire z                           //control signal for Jump instructions
);

reg [WIDTH-1:0] value;
reg flagOut;
always @(*) begin
    value <= R1-R2; 
	flagOut <= (value == 8'b0);
end

assign z = flagOut;
    
endmodule 