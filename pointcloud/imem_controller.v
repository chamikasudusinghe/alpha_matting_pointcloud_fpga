module imem_controller#(parameter WIDTH=8)(
    input Clk,
    input iROMREAD_1, iROMREAD_2, iROMREAD_3, iROMREAD_4, iROMREAD_5, iROMREAD_6, iROMREAD_7, iROMREAD_8,                //rEn signals from each core
    input coreS_1, coreS_2, coreS_3,coreS_4, coreS_5, coreS_6, coreS_7, coreS_8,                           //core states from each core
    input [WIDTH-1:0] PC_1, PC_2, PC_3,PC_4, PC_5, PC_6, PC_7, PC_8,                            //addresses from each core
    input [WIDTH-1:0]INS,                                               //Instruction from IROM
    output reg rEN,                                                     //rEn signal to IROM
    output reg [WIDTH-1:0] PC_OUT,                                      //read address to IROM
    output reg [WIDTH-1:0]INS_1, INS_2, INS_3,INS_4, INS_5, INS_6, INS_7, INS_8,                   //read instructions to cores
    output reg imemAV1, imemAV2, imemAV3,imemAV4, imemAV5, imemAV6, imemAV7, imemAV8                       //IROM read state signal to each core
);
localparam NORMI = 3'b000;
localparam NORMENDI = 3'b001; 

reg [2:0] NEXT_STATE_IC=NORMI;
reg [2:0] STATE_IC=NORMI;



always @(negedge Clk) begin
    STATE_IC = NEXT_STATE_IC;
    case (STATE_IC)
    NORMI:
        if ((coreS_1==0) && (coreS_2==0) && (coreS_3==0) && (coreS_4==0) && (coreS_5==0) && (coreS_6==0) && (coreS_7==0) && (coreS_8==0)) begin
            if(iROMREAD_1==1 && iROMREAD_2==1 && iROMREAD_3==1 && iROMREAD_4==1 && iROMREAD_5==1 && iROMREAD_6==1 && iROMREAD_7==1 && iROMREAD_8==1) begin
                rEN <= 1;
                PC_OUT <= PC_1;
                NEXT_STATE_IC <= NORMENDI;
                imemAV1 <= 1;
                imemAV2 <= 1;
                imemAV3 <= 1;
                imemAV4 <= 1;
                imemAV5 <= 1;
                imemAV6 <= 1;
                imemAV7 <= 1;
                imemAV8 <= 1;
            end
            else begin
                rEN <= 0;
                imemAV1 <= 0;
                imemAV2 <= 0;
                imemAV3 <= 0;
                imemAV4 <= 0;
                imemAV5 <= 0;
                imemAV6 <= 0;
                imemAV7 <= 0;
                imemAV8 <= 0;
                NEXT_STATE_IC <= NORMI;

            end
        end
        else if((coreS_1==0) && (coreS_2==0) && (coreS_3==0) && (coreS_4==0) && (coreS_5==0) && (coreS_6==0) && (coreS_7==0) && (coreS_8==1)) begin
            if(iROMREAD_1==1 && iROMREAD_2==1 && iROMREAD_3==1 && iROMREAD_4==1 && iROMREAD_5==1 && iROMREAD_6==1 && iROMREAD_7==1) begin
               rEN <= 1;
               PC_OUT <= PC_1;
               NEXT_STATE_IC <= NORMENDI;
                imemAV1 <= 1;
                imemAV2 <= 1;
                imemAV3 <= 1;
                imemAV4 <= 1;
                imemAV5 <= 1;
                imemAV6 <= 1;
                imemAV7 <= 1;              
            end
            else begin
                rEN <= 0;
                imemAV1 <= 0;
                imemAV2 <= 0;
                imemAV3 <= 0;
                imemAV4 <= 0;
                imemAV5 <= 0;
                imemAV6 <= 0;
                imemAV7 <= 0;
                NEXT_STATE_IC <= NORMI;

            end
            
        end

        else if((coreS_1==0) && (coreS_2==0) && (coreS_3==0) && (coreS_4==0) && (coreS_5==0) && (coreS_6==0) && (coreS_7==1) && (coreS_8==1)) begin
            if(iROMREAD_1==1 && iROMREAD_2==1 && iROMREAD_3==1 && iROMREAD_4==1 && iROMREAD_5==1 && iROMREAD_6==1) begin
               rEN <= 1;
               PC_OUT <= PC_1;
               NEXT_STATE_IC <= NORMENDI;
                imemAV1 <= 1;
                imemAV2 <= 1;
                imemAV3 <= 1;
                imemAV4 <= 1;
                imemAV5 <= 1;
                imemAV6 <= 1;
                           
            end
            else begin
                rEN <= 0;
                imemAV1 <= 0;
                imemAV2 <= 0;
                imemAV3 <= 0;
                imemAV4 <= 0;
                imemAV5 <= 0;
                imemAV6 <= 0;
             
                NEXT_STATE_IC <= NORMI;

            end
            
        end

        else if((coreS_1==0) && (coreS_2==0) && (coreS_3==0) && (coreS_4==0) && (coreS_5==0) && (coreS_6==1) && (coreS_7==1) && (coreS_8==1)) begin
            if(iROMREAD_1==1 && iROMREAD_2==1 && iROMREAD_3==1 && iROMREAD_4==1 && iROMREAD_5==1) begin
               rEN <= 1;
               PC_OUT <= PC_1;
               NEXT_STATE_IC <= NORMENDI;
                imemAV1 <= 1;
                imemAV2 <= 1;
                imemAV3 <= 1;
                imemAV4 <= 1;
                imemAV5 <= 1;
                            
            end
            else begin
                rEN <= 0;
                imemAV1 <= 0;
                imemAV2 <= 0;
                imemAV3 <= 0;
                imemAV4 <= 0;
                imemAV5 <= 0;
                NEXT_STATE_IC <= NORMI;

            end
            
        end

        else if((coreS_1==0) && (coreS_2==0) && (coreS_3==0) && (coreS_4==0) && (coreS_5==1) && (coreS_6==1) && (coreS_7==1) && (coreS_8==1)) begin
            if(iROMREAD_1==1 && iROMREAD_2==1 && iROMREAD_3==1 && iROMREAD_4==1) begin
               rEN <= 1;
               PC_OUT <= PC_1;
               NEXT_STATE_IC <= NORMENDI;
                imemAV1 <= 1;
                imemAV2 <= 1;
                imemAV3 <= 1;
                imemAV4 <= 1;
                          
            end
            else begin
                rEN <= 0;
                imemAV1 <= 0;
                imemAV2 <= 0;
                imemAV3 <= 0;
                imemAV4 <= 0;
                NEXT_STATE_IC <= NORMI;

            end
            
        end

        else if((coreS_1==0) && (coreS_2==0) && (coreS_3==0) && (coreS_4==1) && (coreS_5==1) && (coreS_6==1) && (coreS_7==1) && (coreS_8==1)) begin
            if(iROMREAD_1==1 && iROMREAD_2==1 && iROMREAD_3==1) begin
               rEN <= 1;
               PC_OUT <= PC_1;
               NEXT_STATE_IC <= NORMENDI;
                imemAV1 <= 1;
                imemAV2 <= 1;
                imemAV3 <= 1;
               
                          
            end
            else begin
                rEN <= 0;
                imemAV1 <= 0;
                imemAV2 <= 0;
                imemAV3 <= 0;
                NEXT_STATE_IC <= NORMI;

            end
            
        end

        else if((coreS_1==0) && (coreS_2==0) && (coreS_3==1) && (coreS_4==1) && (coreS_5==1) && (coreS_6==1) && (coreS_7==1) && (coreS_8==1)) begin
            if(iROMREAD_1==1 && iROMREAD_2==1) begin
               rEN <= 1;
               PC_OUT <= PC_1;
               NEXT_STATE_IC <= NORMENDI;
                imemAV1 <= 1;
                imemAV2 <= 1;
               
              
                          
            end
            else begin
                rEN <= 0;
                imemAV1 <= 0;
                imemAV2 <= 0;
                NEXT_STATE_IC <= NORMI;

            end
            
        end

        else if((coreS_1==0) && (coreS_2==1) && (coreS_3==1) && (coreS_4==1) && (coreS_5==1) && (coreS_6==1) && (coreS_7==1) && (coreS_8==1)) begin
            if(iROMREAD_1==1) begin
               rEN <= 1;
               PC_OUT <= PC_1;
               NEXT_STATE_IC <= NORMENDI;
                imemAV1 <= 1;
              
             
                          
            end
            else begin
                rEN <= 0;
                imemAV1 <= 0;
                NEXT_STATE_IC <= NORMI;

            end
            
        end

    
    NORMENDI:
      if((coreS_1==0) && (coreS_2==0) && (coreS_3==0) && (coreS_4==0) && (coreS_5==0) && (coreS_6==0) && (coreS_7==0) && (coreS_8==0)) begin
        INS_1 <= INS;
        INS_2 <= INS;
        INS_3 <= INS;
        INS_4 <= INS;
        INS_5 <= INS;
        INS_6 <= INS;
        INS_7 <= INS;
        INS_8 <= INS;
        imemAV1 <= 1;
        imemAV2 <= 1;
        imemAV3 <= 1;
        imemAV4 <= 1;
        imemAV5 <= 1;
        imemAV6 <= 1;
        imemAV7 <= 1;
        imemAV8 <= 1;
        NEXT_STATE_IC <= NORMI;     
      end

      else if((coreS_1==0) && (coreS_2==0) && (coreS_3==0) && (coreS_4==0) && (coreS_5==0) && (coreS_6==0) && (coreS_7==0) && (coreS_8==1)) begin
        INS_1 <= INS;
        INS_2 <= INS;
        INS_3 <= INS;
        INS_4 <= INS;
        INS_5 <= INS;
        INS_6 <= INS;
        INS_7 <= INS;
        imemAV1 <= 1;
        imemAV2 <= 1;
        imemAV3 <= 1;
        imemAV4 <= 1;
        imemAV5 <= 1;
        imemAV6 <= 1;
        imemAV7 <= 1;
        NEXT_STATE_IC <= NORMI;     
      end

     else if((coreS_1==0) && (coreS_2==0) && (coreS_3==0) && (coreS_4==0) && (coreS_5==0) && (coreS_6==0) && (coreS_7==1) && (coreS_8==1)) begin
        INS_1 <= INS;
        INS_2 <= INS;
        INS_3 <= INS;
        INS_4 <= INS;
        INS_5 <= INS;
        INS_6 <= INS;
        imemAV1 <= 1;
        imemAV2 <= 1;
        imemAV3 <= 1;
        imemAV4 <= 1;
        imemAV5 <= 1;
        imemAV6 <= 1;
        NEXT_STATE_IC <= NORMI;     
      end

      else if((coreS_1==0) && (coreS_2==0) && (coreS_3==0) && (coreS_4==0) && (coreS_5==0) && (coreS_6==1) && (coreS_7==1) && (coreS_8==1)) begin
        INS_1 <= INS;
        INS_2 <= INS;
        INS_3 <= INS;
        INS_4 <= INS;
        INS_5 <= INS;
        imemAV1 <= 1;
        imemAV2 <= 1;
        imemAV3 <= 1;
        imemAV4 <= 1;
        imemAV5 <= 1;
        NEXT_STATE_IC <= NORMI;     
      end

      else if((coreS_1==0) && (coreS_2==0) && (coreS_3==0) && (coreS_4==0) && (coreS_5==1) && (coreS_6==1) && (coreS_7==1) && (coreS_8==1)) begin
        INS_1 <= INS;
        INS_2 <= INS;
        INS_3 <= INS;
        INS_4 <= INS;
        imemAV1 <= 1;
        imemAV2 <= 1;
        imemAV3 <= 1;
        imemAV4 <= 1;
        NEXT_STATE_IC <= NORMI;     
      end

      else if((coreS_1==0) && (coreS_2==0) && (coreS_3==0) && (coreS_4==1) && (coreS_5==1) && (coreS_6==1) && (coreS_7==1) && (coreS_8==1)) begin
        INS_1 <= INS;
        INS_2 <= INS;
        INS_3 <= INS;
        imemAV1 <= 1;
        imemAV2 <= 1;
        imemAV3 <= 1;
        NEXT_STATE_IC <= NORMI;     
      end

      else if((coreS_1==0) && (coreS_2==0) && (coreS_3==1) && (coreS_4==1) && (coreS_5==1) && (coreS_6==1) && (coreS_7==1) && (coreS_8==1)) begin
        INS_1 <= INS;
        INS_2 <= INS;
        imemAV1 <= 1;
        imemAV2 <= 1;
        NEXT_STATE_IC <= NORMI;     
      end

      else if((coreS_1==0) && (coreS_2==1) && (coreS_3==1) && (coreS_4==1) && (coreS_5==1) && (coreS_6==1) && (coreS_7==1) && (coreS_8==1)) begin
        INS_1 <= INS;
        imemAV1 <= 1;
        NEXT_STATE_IC <= NORMI;     
      end





    endcase

end

endmodule
    
    
    
    
    
    