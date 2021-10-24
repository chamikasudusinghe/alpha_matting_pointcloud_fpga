module AR //write enable /IR, AR, Rp, Rt, Rk1, Rm1, Rn1, C1
#(parameter WIDTH = 8)
(
input Clk, WEN, selAR, coreINC_AR,
input [WIDTH-1:0] IOut, BusOut, 
input [2:0] coreID,
output [WIDTH-1:0] dout
);

reg [WIDTH-1:0] value;

always @(negedge Clk) 
begin
    if(WEN==1 && selAR == 0 && coreINC_AR == 0) begin 
        value <= BusOut;   
    end
    if (coreINC_AR==1) begin                                    //will be used in the COPYRm1 & COPYT4
        value <= value + coreID;
    end
    if(WEN==1 && selAR == 1 && coreINC_AR == 0) begin 
        value <= IOut;   
    end
end

assign dout=value;
    
endmodule