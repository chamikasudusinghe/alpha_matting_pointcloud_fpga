`timescale 1ns/1ps
module Comp_tb ();
    localparam CLK_PERIOD = 10;
    reg Clk;

    initial begin
        Clk=1'b0;
        forever begin
            #(CLK_PERIOD/2);
            Clk <= ~Clk;    
        end
    end

    localparam WIDTH = 8;
    reg [WIDTH-1:0] R1, R2;
    wire [WIDTH-1:0] value;
    wire z;

Comp #(.WIDTH(WIDTH)) dut (.R1(R1), .R2(R2), .z(z));

initial begin
    #(CLK_PERIOD);

    @(posedge Clk);
    R1=8'b10101010;
    R2=8'b10101010;

    #(CLK_PERIOD);
    @(posedge Clk);
    R1=8'b11110000;
    R2=8'b10000000;

    #(CLK_PERIOD);
    @(posedge Clk);
    R1=8'b11101010;
    R2=8'b11101010;

    repeat(3) @(posedge Clk) begin
            R1=$random;
            R2=$random;
            $display("%8b", R1);
            $display("%8b", R2);
    end

    $stop;

end   
endmodule

    
