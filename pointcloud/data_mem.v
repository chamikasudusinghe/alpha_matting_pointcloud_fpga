// Quartus Prime Verilog Template
// Single port RAM with single read/write address 

module data_mem 
#(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=8)
(
	input [(DATA_WIDTH-1):0] data,
	input [(ADDR_WIDTH-1):0] addr,
	input wEn, clk, rEn, nextLoop,
	output [(DATA_WIDTH-1):0] mem_out
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];

	// Variable to hold the registered read address
	reg [ADDR_WIDTH-1:0] addr_reg;
	//reg [4:0] trial_no = 5'b00000;
	//reg [8*15:1] path;

	//path = {path,trial_no}

	//outfile
	integer outfile;

	initial begin
		$readmemh("C:\\Users\\ChamikaIshanSudusing\\Documents\\pointcloud\\data_mem.txt",ram);
	end

	always @ (negedge clk)
	begin
		if (nextLoop)begin
			$writememh("C:\\Users\\ChamikaIshanSudusing\\Documents\\pointcloud\\result1.txt",ram);
//			trial_no = trial_no + 5'b00001;
			$readmemh("C:\\Users\\ChamikaIshanSudusing\\Documents\\pointcloud\\data_mem2.txt",ram);
		end		
		
		// Write
		if (wEn) begin
			ram[addr] <= data;
			addr_reg <= addr;
		end
		if (rEn) begin	
			addr_reg <= addr;
		end
		$writememh("C:\\Users\\ChamikaIshanSudusing\\Documents\\pointcloud\\result2.txt",ram);
	end
	
	assign mem_out = ram[addr_reg];

endmodule



