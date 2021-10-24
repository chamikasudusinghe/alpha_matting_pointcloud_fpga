`timescale 1ns/1ps

module ins_mem_tb();

localparam ADDR_WIDTH = 8;
localparam INS_WIDTH = 8;
localparam CLK_PERIOD = 20;

reg [(ADDR_WIDTH-1):0] addr;
reg clk, rEn;
wire [(INS_WIDTH-1):0] instruction;

/////create clock/////
initial begin
    clk = 1'b0;
    forever begin
        #(CLK_PERIOD/2);
        clk = ~clk;
    end
end

////instantiate the module in the test bench////
ins_mem #(.ADDR_WIDTH(ADDR_WIDTH), .INS_WIDTH(INS_WIDTH)) ins_mem(.instruction(instruction), .PC_address(addr), .clk(clk), .rEn(rEn));

initial begin
    
    @(posedge clk);
    rEn <= 1;
    addr <= 8'h00;


    @(posedge clk);
    rEn <= 1;
    addr <= 8'h01;


    @(posedge clk);
    rEn =0;
    addr <= 8'h02;

    @(posedge clk);
    rEn <= 1;
    addr <= 8'h0A;  

    repeat(10) @(posedge clk) begin
        rEn <= $random;
        addr <= $random;
        $display("%8b", addr);
    end

    $stop;
end

endmodule