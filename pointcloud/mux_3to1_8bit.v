module mux_3to1_8bit(mux_inN, mux_inK, mux_inM, mux_sel, mux_out);
input [2:0] mux_sel;
input [7:0] mux_inN, mux_inK, mux_inM;
output [7:0] mux_out;
// The output is defined as register 
reg [7:0] mux_out;
always @(*)
begin
    case(mux_sel)
        3'b001:
            mux_out <= mux_inN;
        3'b010:
            mux_out <= mux_inK;
        3'b100:
            mux_out <= mux_inM;
        default: 
            mux_out <= 8'bz;
    endcase

    
end
   
endmodule

