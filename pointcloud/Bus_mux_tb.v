`timescale 1ns/1ps
module Bus_mux_tb();

    localparam CLK_PERIOD = 20;
    reg Clk;

    initial begin
        Clk = 1'b0;
        forever begin
            #(CLK_PERIOD/2);
            Clk = ~Clk;
        end
    end

    reg [3:0] mux_sel;
    reg [7:0] MEM, AR, DR, RP, RT, RM1, RK1, RN1, RM2, RK2, RN2, C1,  C2,  C3,  AC;
    wire [7:0] Bus_select;

    Bus_mux dut(.MEM(MEM), .AR(AR), .DR(DR), .RP(RP), .RT(RT), .RM1(RM1), .RK1(RK1), .RN1(RN1), .RM2(RM2), .RK2(RK2), .RN2(RN2), .C1(C1), .C2(C2), .C3(C3), .AC(AC), .mux_sel(mux_sel), .Bus_select(Bus_select));

    initial begin
        

        #(CLK_PERIOD);
        
        repeat(5) @(posedge Clk) begin
            mux_sel=$random;
            MEM=$random;
            AR=$random;
            DR=$random;
            RP=$random;
            RT=$random;
            RM1=$random;
            RK1=$random;
            RN1=$random;
            RM2=$random;
            RK2=$random;
            RN2=$random;
            C1=$random;
            C2=$random;
            C3=$random;
            AC=$random;
          
        end
     $stop;
    end
endmodule





    