`timescale 1ns/1ps
module processor_tb();
    localparam CLK_PERIOD = 20;
    reg Clk;
    wire proc_state;
    initial begin
        Clk = 1'b1;
        forever begin
            #(CLK_PERIOD/2);
            Clk = ~Clk;
        end
    end

    processor # (.WIDTH(8)) proc( .clk(Clk), .proc_state(proc_state));

    always @(posedge Clk) begin
        if (proc_state == 1)begin
            $stop;
        end
    end

endmodule