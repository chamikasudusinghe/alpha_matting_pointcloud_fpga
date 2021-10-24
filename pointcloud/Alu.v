module Alu #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] AC, BusOut,
    input [3:0] ALU_OP,
    input [WIDTH-1:0] MEM_ID,
    output [WIDTH-1:0] result_ac
);

	localparam SET = 4'b0001;
	localparam MUL = 4'b0010;
	localparam ADD = 4'b0100;
    localparam ADDMEM = 4'b1000;

    
    reg [WIDTH-1:0] result;
    
    always @(*) begin
    	case (ALU_OP)
            SET: 
                result<=BusOut;
            MUL:
                result<=AC*BusOut;
            ADD:
                result<=AC+BusOut;
            ADDMEM:
                result <= AC+MEM_ID;
            default: 
                result<=AC;
        endcase    
    end
    assign result_ac = result;
		 
endmodule