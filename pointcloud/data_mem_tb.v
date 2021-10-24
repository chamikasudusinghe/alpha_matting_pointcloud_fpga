`timescale 1ns/1ps

module data_mem_tb();

localparam DATA_WIDTH = 8;
localparam ADDR_WIDTH = 8;
localparam CLK_PERIOD = 20;

reg [(DATA_WIDTH - 1):0] data;
reg [(ADDR_WIDTH-1):0] addr;
reg wEn, clk, rEn;
wire [(DATA_WIDTH-1):0] mem_out;

/////create clock/////
initial begin
    clk = 1'b0;
    forever begin
        #(CLK_PERIOD/2);
        clk = ~clk;
    end
end

////instantiate the module in the test bench////
data_mem #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) dt_mem(.data(data), .addr(addr), .wEn(wEn), .clk(clk), .mem_out(mem_out), .rEn(rEn));

initial begin
    
    @(posedge clk);
    rEn <= 0;
    wEn <= 1;
    addr <= 0;
    data <= 32;

    @(posedge clk);
    //wEn <= 1;
    addr <= 1;
    data <= 33;

    @(posedge clk);
    //wEn <= 1;
    addr <= 2;
    data <= 34;

    @(posedge clk);
    wEn <= 0;
    rEn <= 1;
    addr <= 1;
    data <= 32;

    @(posedge clk);
    wEn <= 0;
    addr <= 3;
    data <= 32;

    @(posedge clk);
    wEn <= 0;
    rEn <= 0;
    addr <= 5;
    data <= 32;     

    @(posedge clk);
    wEn <= 0;
    rEn <= 1;
    addr <= 25;
    data <= 32;    

    repeat(10) @(posedge clk) begin
        wEn <= $random;
        addr <= $random;
        data <= $random;

        $display("%8b", data);
    end

    $stop;
end

endmodule

