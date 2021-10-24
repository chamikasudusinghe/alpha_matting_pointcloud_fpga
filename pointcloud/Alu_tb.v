`timescale 1ns/1ps
module Alu_tb ();
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
    reg [WIDTH-1:0] AC, BusOut;
    reg [3:0] ALU_OP;
    input [WIDTH-1:0] coreID;
    wire [WIDTH-1:0] result_ac;
    

    Alu #(.WIDTH(WIDTH)) dut (.AC(AC), .BusOut(BusOut), .result_ac(result_ac), .ALU_OP(ALU_OP), .coreID(coreID));

    initial begin
        #(CLK_PERIOD*2);

        @(posedge Clk);
        AC=8'b00010101;
        coreID = 8'b00000001;
        BusOut=8'b10101010;
        ALU_OP=3'b0001;

        #(CLK_PERIOD*2);
        @(posedge Clk);
        AC=8'b00010101;
        coreID = 8'b00000010;
        BusOut=8'b10101010;
        ALU_OP=3'b0100;

        @(posedge Clk);
        AC=8'b00010101;
        coreID = 8'b00000010;
        BusOut=8'b10101010;
        // ALU_OP=3'b010;

        @(posedge Clk);
        AC=8'b00010101;
        coreID = 8'b00000011;
        BusOut=8'b10101010;
        ALU_OP=3'b1000;

       
        repeat(5) @(posedge Clk) begin
            BusOut <= $random;
            AC <= $random;
            coreID <= $random;
            ALU_OP <= $random;
            $display("%8b", BusOut);
            $display("%8b", AC);
        end

        $stop;

    end   
endmodule