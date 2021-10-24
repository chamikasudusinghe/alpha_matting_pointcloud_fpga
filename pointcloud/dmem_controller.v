module dmem_controller#(parameter WIDTH=8)(
    input Clk,
    input coreS_1, coreS_2, coreS_3,coreS_4, coreS_5, coreS_6, coreS_7, coreS_8,
    input [WIDTH-1:0] AR_1, AR_2, AR_3,AR_4, AR_5, AR_6, AR_7, AR_8,
    input [WIDTH-1:0] DR_1, DR_2, DR_3, DR_4, DR_5, DR_6, DR_7, DR_8,   
    input [WIDTH-1:0]MEM,                                       //from DRAM
    input memREAD_1, memREAD_2, memREAD_3,memREAD_4, memREAD_5, memREAD_6, memREAD_7, memREAD_8,
    input memWE_1, memWE_2, memWE_3,memWE_4, memWE_5, memWE_6, memWE_7, memWE_8,
    output reg rEN,
    output reg wEN,
    output reg [WIDTH-1:0] MEM_1, MEM_2, MEM_3,MEM_4, MEM_5, MEM_6, MEM_7, MEM_8,      
    output reg [WIDTH-1:0] addr,                                //to DRAM
    output reg [WIDTH-1:0] DR_OUT,
    output reg memAV1, memAV2, memAV3,memAV4, memAV5, memAV6, memAV7, memAV8                   //to cores
);
localparam NORM = 5'b00000;
localparam NORMEND =5'b00001;

localparam AR_1_2 = 5'b00010;
localparam AR_2_1 = 5'b00011;
localparam AR_2_2 = 5'b00100;
localparam AR_3_1 = 5'b00101;
localparam AR_3_2 = 5'b00110;
localparam AR_4_1 = 5'b00111;
localparam AR_4_2 = 5'b01000;
localparam AR_5_1 = 5'b01001;
localparam AR_5_2 = 5'b01010;
localparam AR_6_1 = 5'b01011;
localparam AR_6_2 = 5'b01100;
localparam AR_7_1 = 5'b01101;
localparam AR_7_2 = 5'b01110;
localparam AR_8_1 = 5'b01111;
localparam AR_8_2 = 5'b10000;

localparam DR_1_1 = 5'b10001;
localparam DR_1_2 = 5'b10010;
localparam DR_1_3 = 5'b10011;
localparam DR_1_4 = 5'b10100;
localparam DR_1_5 = 5'b10101;
localparam DR_1_6 = 5'b10110;
localparam DR_1_7 = 5'b10111;

reg [4:0] NEXT_STATE_DC=NORM;
reg [4:0] STATE_DC = NORM;

always @(posedge Clk) begin
    STATE_DC=NEXT_STATE_DC;
    case (STATE_DC)
     NORM: begin
        memAV1 <= 0;
        memAV2 <= 0;
        memAV3 <= 0;
        memAV4 <= 0;
        memAV5 <= 0;
        memAV6 <= 0;
        memAV7 <= 0;
        memAV8 <= 0;
        rEN <= 0;
        wEN <= 0;
        if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==0) begin
            if(memREAD_1==1 && memREAD_2==1 && memREAD_3==1 && memREAD_4==1 && memREAD_5==1 && memREAD_6==1 && memREAD_7==1 && memREAD_8==1) begin
                if(AR_1==AR_2 && AR_2==AR_3 && AR_3==AR_4 && AR_4==AR_5 && AR_5==AR_6 && AR_6==AR_7 && AR_7==AR_8) begin // Active 8 cores, same addresses
                    rEN <= 1;
                    addr <= AR_1;
                    NEXT_STATE_DC <= NORMEND;
                    memAV1 <= 1;
                    memAV2 <= 1;
                    memAV3 <= 1;
                    memAV4 <= 1;
                    memAV5 <= 1;
                    memAV6 <= 1;
                    memAV7 <= 1;
                    memAV8 <= 1;

                end
                else begin           // Active 8 cores, different addresses
                    rEN <= 1;
                    addr <= AR_1;
                    NEXT_STATE_DC <= AR_1_2;
                end 
              end
              else if(memWE_1==1 && memWE_2==1 && memWE_3==1 && memWE_4==1 && memWE_5==1 && memWE_6==1 && memWE_7==1 && memWE_8==1) begin
                  wEN <= 1;
                  addr <= AR_1;
                  DR_OUT <= DR_1;
                  memAV1 <= 0;
                  memAV2 <= 0;
                  memAV3 <= 0;
                  memAV4 <= 0;
                  memAV5 <= 0;
                  memAV6 <= 0;
                  memAV7 <= 0;
                  memAV8 <= 0;
                  NEXT_STATE_DC <= DR_1_1;
              end
          end
          else if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==1) begin
              if(memREAD_1==1 && memREAD_2==1 && memREAD_3==1 && memREAD_4==1 && memREAD_5==1 && memREAD_6==1 && memREAD_7==1) begin
                  if(AR_1==AR_2 && AR_2==AR_3 && AR_3==AR_4 && AR_4==AR_5 && AR_5==AR_6 && AR_6==AR_7) begin 
                    rEN <= 1;
                    addr <= AR_1;
                    NEXT_STATE_DC <= NORMEND;
                    memAV1 <= 1;
                    memAV2 <= 1;
                    memAV3 <= 1;
                    memAV4 <= 1;
                    memAV5 <= 1;
                    memAV6 <= 1;
                    memAV7 <= 1;
                end
                else begin
                    rEN <= 1;
                    addr <= AR_1;
                    NEXT_STATE_DC <= AR_1_2;
                end
              end
              else if(memWE_1==1 && memWE_2==1 && memWE_3==1 && memWE_4==1 && memWE_5==1 && memWE_6==1 && memWE_7==1) begin
                  wEN <= 1;
                  addr <= AR_1;
                  DR_OUT <= DR_1;
                  memAV1 <= 0;
                  memAV2 <= 0;
                  memAV3 <= 0;
                  memAV4 <= 0;
                  memAV5 <= 0;
                  memAV6 <= 0;
                  memAV7 <= 0;
                  NEXT_STATE_DC <= DR_1_1;
              end
              
          end 

          else if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==1 && coreS_8==1) begin
              if(memREAD_1==1 && memREAD_2==1 && memREAD_3==1 && memREAD_4==1 && memREAD_5==1 && memREAD_6==1) begin
                  if(AR_1==AR_2 && AR_2==AR_3 && AR_3==AR_4 && AR_4==AR_5 && AR_5==AR_6) begin 
                    rEN <= 1;
                    addr <= AR_1;
                    NEXT_STATE_DC <= NORMEND;
                    memAV1 <= 1;
                    memAV2 <= 1;
                    memAV3 <= 1;
                    memAV4 <= 1;
                    memAV5 <= 1;
                    memAV6 <= 1;
                end
                else begin
                    rEN <= 1;
                    addr <= AR_1;
                    NEXT_STATE_DC <= AR_1_2;
                end
              end
              else if(memWE_1==1 && memWE_2==1 && memWE_3==1 && memWE_4==1 && memWE_5==1 && memWE_6==1) begin
                  wEN <= 1;
                  addr <= AR_1;
                  DR_OUT <= DR_1;
                  memAV1 <= 0;
                  memAV2 <= 0;
                  memAV3 <= 0;
                  memAV4 <= 0;
                  memAV5 <= 0;
                  memAV6 <= 0;
                  NEXT_STATE_DC <= DR_1_1;
              end
              
          end 

          else if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
              if(memREAD_1==1 && memREAD_2==1 && memREAD_3==1 && memREAD_4==1 && memREAD_5==1) begin
                  if(AR_1==AR_2 && AR_2==AR_3 && AR_3==AR_4 && AR_4==AR_5) begin 
                    rEN <= 1;
                    addr <= AR_1;
                    NEXT_STATE_DC <= NORMEND;
                    memAV1 <= 1;
                    memAV2 <= 1;
                    memAV3 <= 1;
                    memAV4 <= 1;
                    memAV5 <= 1;
                  end
                  else begin
                    rEN <= 1;
                    addr <= AR_1;
                    NEXT_STATE_DC <= AR_1_2;      
                  end
              end

              else if(memWE_1==1 && memWE_2==1 && memWE_3==1 && memWE_4==1 && memWE_5==1) begin
                  wEN <= 1;
                  addr <= AR_1;
                  DR_OUT <= DR_1;
                  memAV1 <= 0;
                  memAV2 <= 0;
                  memAV3 <= 0;
                  memAV4 <= 0;
                  memAV5 <= 0;
                  NEXT_STATE_DC <= DR_1_1;
              end
          end
          else if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==1 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
              if(memREAD_1==1 && memREAD_2==1 && memREAD_3==1 && memREAD_4==1) begin
                  if(AR_1==AR_2 && AR_2==AR_3 && AR_3==AR_4) begin 
                    rEN <= 1;
                    addr <= AR_1;
                    NEXT_STATE_DC <= NORMEND;
                    memAV1 <= 1;
                    memAV2 <= 1;
                    memAV3 <= 1;
                    memAV4 <= 1;
                  end
                  else begin
                    rEN <= 1;
                    addr <= AR_1;
                    NEXT_STATE_DC <= AR_1_2;      
                  end
              end

              else if(memWE_1==1 && memWE_2==1 && memWE_3==1 && memWE_4==1) begin
                  wEN <= 1;
                  addr <= AR_1;
                  DR_OUT <= DR_1;
                  memAV1 <= 0;
                  memAV2 <= 0;
                  memAV3 <= 0;
                  memAV4 <= 0;
                  NEXT_STATE_DC <= DR_1_1;
              end
              
          end
          else if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==1 && coreS_5==1 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
              if(memREAD_1==1 && memREAD_2==1 && memREAD_3==1) begin
                  if(AR_1==AR_2 && AR_2==AR_3) begin 
                    rEN <= 1;
                    addr <= AR_1;
                    NEXT_STATE_DC <= NORMEND;
                    memAV1 <= 1;
                    memAV2 <= 1;
                    memAV3 <= 1;
                  end
                  else begin
                    rEN <= 1;
                    addr <= AR_1;
                    NEXT_STATE_DC <= AR_1_2;      
                  end
              end

              else if(memWE_1==1 && memWE_2==1 && memWE_3==1) begin
                  wEN <= 1;
                  addr <= AR_1;
                  DR_OUT <= DR_1;
                  memAV1 <= 0;
                  memAV2 <= 0;
                  memAV3 <= 0;
                  NEXT_STATE_DC <= DR_1_1;
              end
              
          end 

          else if (coreS_1==0 && coreS_2==0 && coreS_3==1 && coreS_4==1 && coreS_5==1 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
              if(memREAD_1==1 && memREAD_2==1) begin
                  if(AR_1==AR_2) begin 
                    rEN <= 1;
                    addr <= AR_1;
                    NEXT_STATE_DC <= NORMEND;
                    memAV1 <= 1;
                    memAV2 <= 1;
                  end
                  else begin
                    rEN <= 1;
                    addr <= AR_1;
                    NEXT_STATE_DC <= AR_1_2;      
                  end
              end
              else if(memWE_1==1 && memWE_2==1) begin
                  wEN <= 1;
                  addr <= AR_1;
                  DR_OUT <= DR_1;
                  memAV1 <= 0;
                  memAV2 <= 0;
                  NEXT_STATE_DC <= DR_1_1;
              end
              
          end 

          else if (coreS_1==0 && coreS_2==1 && coreS_3==1 && coreS_4==1 && coreS_5==1 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
              if(memREAD_1==1) begin
                    rEN <= 1;
                    addr <= AR_1;
                    NEXT_STATE_DC <= NORMEND;
                    memAV1 <= 1;
              end
              else if(memWE_1==1) begin
                  wEN <= 1;
                  addr <= AR_1;
                  DR_OUT <= DR_1;
                  memAV1 <= 1;
                  NEXT_STATE_DC <= NORM;
              end    
          end 
                
      end
      NORMEND: begin
          if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==0) begin
            MEM_1 <= MEM;
            MEM_2 <= MEM;
            MEM_3 <= MEM;
            MEM_4 <= MEM;
            MEM_5 <= MEM;
            MEM_6 <= MEM;
            MEM_7 <= MEM;
            MEM_8 <= MEM;
            memAV1 <= 0;          // memAV = 0 in AR_1
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
            memAV5 <= 0;
            memAV6 <= 0;
            memAV7 <= 0;
            memAV8 <= 0;
          end
          else if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==1) begin
            MEM_1 <= MEM;
            MEM_2 <= MEM;
            MEM_3 <= MEM;
            MEM_4 <= MEM;
            MEM_5 <= MEM;
            MEM_6 <= MEM;
            MEM_7 <= MEM;
            memAV1 <= 0;          // memAV = 0 in AR_1
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
            memAV5 <= 0;
            memAV6 <= 0;
            memAV7 <= 0;
          end
          else if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==1 && coreS_8==1) begin
            MEM_1 <= MEM;
            MEM_2 <= MEM;
            MEM_3 <= MEM;
            MEM_4 <= MEM;
            MEM_5 <= MEM;
            MEM_6 <= MEM;
            memAV1 <= 0;          // memAV = 0 in AR_1
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
            memAV5 <= 0;
            memAV6 <= 0;
          end
          else if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
            MEM_1 <= MEM;
            MEM_2 <= MEM;
            MEM_3 <= MEM;
            MEM_4 <= MEM;
            MEM_5 <= MEM;
            memAV1 <= 0;          // memAV = 0 in AR_1
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
            memAV5 <= 0;
          end
          else if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==1 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
            MEM_1 <= MEM;
            MEM_2 <= MEM;
            MEM_3 <= MEM;
            MEM_4 <= MEM;
            memAV1 <= 0;          // memAV = 0 in AR_1
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
          end
          else if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==1 && coreS_5==1 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
            MEM_1 <= MEM;
            MEM_2 <= MEM;
            MEM_3 <= MEM;
            memAV1 <= 0;          // memAV = 0 in AR_1
            memAV2 <= 0;
            memAV3 <= 0;
          end
          else if (coreS_1==0 && coreS_2==0 && coreS_3==1 && coreS_4==1 && coreS_5==1 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
            MEM_1 <= MEM;
            MEM_2 <= MEM;
            memAV1 <= 0;          // memAV = 0 in AR_1
            memAV2 <= 0;
          end
          else if (coreS_1==0 && coreS_2==1 && coreS_3==1 && coreS_4==1 && coreS_5==1 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
            MEM_1 <= MEM;
            memAV1 <= 0;          // memAV = 0 in AR_1
          end          
          NEXT_STATE_DC <= NORM;
           
      end

      AR_1_2: begin
          if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==0) begin
            MEM_1 <= MEM;
            memAV1 <= 0;
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0; 
            memAV5 <= 0;
            memAV6 <= 0;
            memAV7 <= 0;
            memAV8 <= 0;
            NEXT_STATE_DC <= AR_2_1;
              
          end
          if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==1) begin
            MEM_1 <= MEM;
            memAV1 <= 0;
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0; 
            memAV5 <= 0;
            memAV6 <= 0;
            memAV7 <= 0;
            NEXT_STATE_DC <= AR_2_1;
              
          end

          if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==1 && coreS_8==1) begin
            MEM_1 <= MEM;
            memAV1 <= 0;
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0; 
            memAV5 <= 0;
            memAV6 <= 0;
            NEXT_STATE_DC <= AR_2_1;
              
          end

          if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
            MEM_1 <= MEM;
            memAV1 <= 0;
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0; 
            memAV5 <= 0;
            NEXT_STATE_DC <= AR_2_1;
              
          end
          if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==1 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
            MEM_1 <= MEM;
            memAV1 <= 0;
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
            NEXT_STATE_DC <= AR_2_1;
              
          end
          if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==1 && coreS_5==1 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
            MEM_1 <= MEM;
            memAV1 <= 0;
            memAV2 <= 0;
            memAV3 <= 0;
            NEXT_STATE_DC <= AR_2_1;
              
          end
          if (coreS_1==0 && coreS_2==0 && coreS_3==1 && coreS_4==1 && coreS_5==1 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
            MEM_1 <= MEM;
            memAV1 <= 0;
            memAV2 <= 0;
            NEXT_STATE_DC <= AR_2_1;
              
          end
          if (coreS_1==0 && coreS_2==1 && coreS_3==1 && coreS_4==1 && coreS_5==1 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
            MEM_1 <= MEM;
            memAV1 <= 0;
            NEXT_STATE_DC <= NORM;
              
          end
               
      end

      AR_2_1: begin
          rEN <= 1;
          addr <= AR_2;
          NEXT_STATE_DC <= AR_2_2;
          if (coreS_1==0 && coreS_2==0 && coreS_3==1 && coreS_4==1 && coreS_5==1 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
            memAV1 <= 1;
            memAV2 <= 1; 
          end         
      end

      AR_2_2: begin
        if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==0) begin
            MEM_2 <= MEM;
            memAV1 <= 0;
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
            memAV5 <= 0;
            memAV6 <= 0;
            memAV7 <= 0;
            memAV8 <= 0;
            NEXT_STATE_DC <= AR_3_1;     
        end

        if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==1) begin
            MEM_2 <= MEM;
            memAV1 <= 0;
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
            memAV5 <= 0;
            memAV6 <= 0;
            memAV7 <= 0;
            NEXT_STATE_DC <= AR_3_1;     
        end

        if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==1 && coreS_8==1) begin
            MEM_2 <= MEM;
            memAV1 <= 0;
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
            memAV5 <= 0;
            memAV6 <= 0;
            NEXT_STATE_DC <= AR_3_1;     
        end
        if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
            MEM_2 <= MEM;
            memAV1 <= 0;
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
            memAV5 <= 0;
            NEXT_STATE_DC <= AR_3_1;     
        end 
        if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==1 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
            MEM_2 <= MEM;
            memAV1 <= 0;
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
            NEXT_STATE_DC <= AR_3_1;     
        end 
        if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==1 && coreS_5==1 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
            MEM_2 <= MEM;
            memAV1 <= 0;
            memAV2 <= 0;
            memAV3 <= 0;
            NEXT_STATE_DC <= AR_3_1;     
        end 
        if (coreS_1==0 && coreS_2==0 && coreS_3==1 && coreS_4==1 && coreS_5==1 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
            MEM_2 <= MEM;
            memAV1 <= 0;
            memAV2 <= 0;
            NEXT_STATE_DC <= NORM;     
        end 
               
      end

      AR_3_1: begin
        rEN <= 1;
        addr <= AR_3;
        NEXT_STATE_DC <= AR_3_2;
        if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==1 && coreS_5==1 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin      //when 3 cores are working
            memAV1 <= 1;
            memAV2 <= 1;
            memAV3 <= 1;
        end
      end

      AR_3_2: begin
          if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==0) begin
            MEM_3 <= MEM;
            memAV1 <= 0;
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
            memAV4 <= 0; 
            memAV5 <= 0;
            memAV6 <= 0;
            memAV7 <= 0;
            memAV8 <= 0; 
            NEXT_STATE_DC <= AR_4_1;
          end

          if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==1) begin
            MEM_3 <= MEM;
            memAV1 <= 0;
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
            memAV4 <= 0; 
            memAV5 <= 0;
            memAV6 <= 0;
            memAV7 <= 0;
            NEXT_STATE_DC <= AR_4_1;
          end

        if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==1 && coreS_8==1) begin
            MEM_3 <= MEM;
            memAV1 <= 0;
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
            memAV4 <= 0; 
            memAV5 <= 0;
            memAV6 <= 0;
            NEXT_STATE_DC <= AR_4_1;
          end
          if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
            MEM_3 <= MEM;
            memAV1 <= 0;
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
            memAV4 <= 0; 
            memAV5 <= 0;
            NEXT_STATE_DC <= AR_4_1;
          end
          if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==1 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
            MEM_3 <= MEM;
            memAV1 <= 0;
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
            NEXT_STATE_DC <= AR_4_1;
          end
          if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==1 && coreS_5==1 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
            MEM_3 <= MEM;
            memAV1 <= 0;
            memAV2 <= 0;
            memAV3 <= 0;
            NEXT_STATE_DC <= NORM;
          end

        

      end

      AR_4_1: begin
        rEN <= 1;
        addr <= AR_4;
        NEXT_STATE_DC <= AR_4_2;
        if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==1 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
            memAV1 <= 1;
            memAV2 <= 1;
            memAV3 <= 1;
            memAV4 <= 1;    
        end
        
      end

      AR_4_2:begin
          if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==0) begin
            MEM_4 <= MEM;
            memAV1 <= 0;   
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
            memAV5 <= 0;
            memAV6 <= 0;
            memAV7 <= 0;
            memAV8 <= 0; 
            NEXT_STATE_DC <= AR_5_1;    
          end

          if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==1) begin
            MEM_4 <= MEM;
            memAV1 <= 0;   
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
            memAV5 <= 0;
            memAV6 <= 0;
            memAV7 <= 0;
            NEXT_STATE_DC <= AR_5_1;    
          end
          if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==1 && coreS_8==1) begin
            MEM_4 <= MEM;
            memAV1 <= 0;   
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
            memAV5 <= 0;
            memAV6 <= 0;
            NEXT_STATE_DC <= AR_5_1;    
          end
          if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
            MEM_4 <= MEM;
            memAV1 <= 0;   
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
            memAV5 <= 0;
            NEXT_STATE_DC <= AR_5_1;    
          end
          if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==1 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
            MEM_4 <= MEM;
            memAV1 <= 0;   
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
            NEXT_STATE_DC <= NORM;    
          end
         
      end

      AR_5_1: begin
        rEN <= 1;
        addr <= AR_5;
        NEXT_STATE_DC <= AR_5_2;
        if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
            memAV1 <= 1;
            memAV2 <= 1;
            memAV3 <= 1;
            memAV4 <= 1;  
            memAV5 <= 1;  
        end
          
      end

       AR_5_2:begin
          if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==0) begin
            MEM_5 <= MEM;
            memAV1 <= 0;   
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
            memAV5 <= 0;
            memAV6 <= 0;
            memAV7 <= 0;
            memAV8 <= 0; 
            NEXT_STATE_DC <= AR_6_1;    
          end
          if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==1) begin
            MEM_5 <= MEM;
            memAV1 <= 0;   
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
            memAV5 <= 0;
            memAV6 <= 0;
            memAV7 <= 0;
            NEXT_STATE_DC <= AR_6_1;    
          end
          if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==1 && coreS_8==1) begin
            MEM_5 <= MEM;
            memAV1 <= 0;   
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
            memAV5 <= 0;
            memAV6 <= 0;
            NEXT_STATE_DC <= AR_6_1;    
          end
          if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
            MEM_5 <= MEM;
            memAV1 <= 0;   
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
            memAV5 <= 0;
            NEXT_STATE_DC <= NORM;    
          end
      end

       AR_6_1: begin
        rEN <= 1;
        addr <= AR_6;
        NEXT_STATE_DC <= AR_6_2;
        if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==1 && coreS_8==1) begin
            memAV1 <= 1;
            memAV2 <= 1;
            memAV3 <= 1;
            memAV4 <= 1;  
            memAV5 <= 1;
            memAV6 <= 1;  
        end
          
      end

      AR_6_2:begin
          if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==0) begin
            MEM_6 <= MEM;
            memAV1 <= 0;   
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
            memAV5 <= 0;
            memAV6 <= 0;
            memAV7 <= 0;
            memAV8 <= 0; 
            NEXT_STATE_DC <= AR_7_1;    
          end
          if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==1) begin
            MEM_6 <= MEM;
            memAV1 <= 0;   
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
            memAV5 <= 0;
            memAV6 <= 0;
            memAV7 <= 0; 
            NEXT_STATE_DC <= AR_7_1;    
          end

          if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==1 && coreS_8==1) begin
            MEM_6 <= MEM;
            memAV1 <= 0;  
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
            memAV5 <= 0;
            memAV6 <= 0;
            NEXT_STATE_DC <= NORM;    
          end
      end

      AR_7_1: begin
        rEN <= 1;
        addr <= AR_7;
        NEXT_STATE_DC <= AR_7_2;
        if (coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==1) begin
            memAV1 <= 1;
            memAV2 <= 1;
            memAV3 <= 1;
            memAV4 <= 1;  
            memAV5 <= 1;
            memAV6 <= 1; 
            memAV7 <= 1; 
        end
          
      end

      AR_7_2:begin
          if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==0) begin
            MEM_7 <= MEM;
            memAV1 <= 0;   
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
            memAV5 <= 0;
            memAV6 <= 0;
            memAV7 <= 0;
            memAV8 <= 0; 
            NEXT_STATE_DC <= AR_8_1;    
          end
          if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==1) begin
            MEM_7 <= MEM;
            memAV1 <= 0;   
            memAV2 <= 0;
            memAV3 <= 0;
            memAV4 <= 0;
            memAV5 <= 0;
            memAV6 <= 0;
            memAV7 <= 0;
            NEXT_STATE_DC <= NORM;    
          end
      end

      AR_8_1: begin
        rEN <= 1;
        addr <= AR_8;
        NEXT_STATE_DC <= AR_8_2;
        memAV1 <= 1;
        memAV2 <= 1;
        memAV3 <= 1;
        memAV4 <= 1;  
        memAV5 <= 1;
        memAV6 <= 1; 
        memAV7 <= 1; 
        memAV8 <= 1;
          
      end

      AR_8_2:begin
        MEM_8 <= MEM;
        memAV1 <= 0;   
        memAV2 <= 0;
        memAV3 <= 0;
        memAV4 <= 0;
        memAV5 <= 0;
        memAV6 <= 0;
        memAV7 <= 0;
        memAV8 <= 0; 
        NEXT_STATE_DC <= NORM;    
          
      end




      DR_1_1:begin
        if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==0) begin
         wEN <= 1;
         addr <= AR_2;
         DR_OUT <= DR_2;
         memAV1 <= 0;
         memAV2 <= 0;
         memAV3 <= 0;
         memAV4 <= 0;
         memAV5 <= 0;
         memAV6 <= 0;
         memAV7 <= 0;
         memAV8 <= 0;

         NEXT_STATE_DC <= DR_1_2;
        end

        else if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==1) begin
         wEN <= 1;
         addr <= AR_2;
         DR_OUT <= DR_2;
         memAV1 <= 0;
         memAV2 <= 0;
         memAV3 <= 0;
         memAV4 <= 0;
         memAV5 <= 0;
         memAV6 <= 0;
         memAV7 <= 0;

         NEXT_STATE_DC <= DR_1_2;
        end
        else if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==1 && coreS_8==1) begin
         wEN <= 1;
         addr <= AR_2;
         DR_OUT <= DR_2;
         memAV1 <= 0;
         memAV2 <= 0;
         memAV3 <= 0;
         memAV4 <= 0;
         memAV5 <= 0;
         memAV6 <= 0;
         NEXT_STATE_DC <= DR_1_2;
        end
        else if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
         wEN <= 1;
         addr <= AR_2;
         DR_OUT <= DR_2;
         memAV1 <= 0;
         memAV2 <= 0;
         memAV3 <= 0;
         memAV4 <= 0;
         memAV5 <= 0;
         NEXT_STATE_DC <= DR_1_2;
        end
        else if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==1 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
         wEN <= 1;
         addr <= AR_2;
         DR_OUT <= DR_2;
         memAV1 <= 0;
         memAV2 <= 0;
         memAV3 <= 0;
         memAV4 <= 0;
         NEXT_STATE_DC <= DR_1_2;
        end
        else if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==1 && coreS_5==1 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
         wEN <= 1;
         addr <= AR_2;
         DR_OUT <= DR_2;
         memAV1 <= 0;
         memAV2 <= 0;
         memAV3 <= 0;
         NEXT_STATE_DC <= DR_1_2;
        end
        else if(coreS_1==0 && coreS_2==0 && coreS_3==1 && coreS_4==1 && coreS_5==1 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
         wEN <= 1;
         addr <= AR_2;
         DR_OUT <= DR_2;
         memAV1 <= 1;
         memAV2 <= 1;
         NEXT_STATE_DC <= NORM;
        end

        
      end

      DR_1_2:begin
        if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==0) begin
         wEN <= 1;
         addr <= AR_3;
         DR_OUT <= DR_3;
         memAV1 <= 0;
         memAV2 <= 0;
         memAV3 <= 0;
         memAV4 <= 0;
         memAV5 <= 0;
         memAV6 <= 0;
         memAV7 <= 0;
         memAV8 <= 0;

         NEXT_STATE_DC <= DR_1_3;
        end
        else if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==1) begin
         wEN <= 1;
         addr <= AR_3;
         DR_OUT <= DR_3;
         memAV1 <= 0;
         memAV2 <= 0;
         memAV3 <= 0;
         memAV4 <= 0;
         memAV5 <= 0;
         memAV6 <= 0;
         memAV7 <= 0;

         NEXT_STATE_DC <= DR_1_3;
        end
        else if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==1 && coreS_8==1) begin
         wEN <= 1;
         addr <= AR_3;
         DR_OUT <= DR_3;
         memAV1 <= 0;
         memAV2 <= 0;
         memAV3 <= 0;
         memAV4 <= 0;
         memAV5 <= 0;
         memAV6 <= 0;
         NEXT_STATE_DC <= DR_1_3;
        end
        else if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
         wEN <= 1;
         addr <= AR_3;
         DR_OUT <= DR_3;
         memAV1 <= 0;
         memAV2 <= 0;
         memAV3 <= 0;
         memAV4 <= 0;
         memAV5 <= 0;
         NEXT_STATE_DC <= DR_1_3;
        end
        else if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
         wEN <= 1;
         addr <= AR_3;
         DR_OUT <= DR_3;
         memAV1 <= 0;
         memAV2 <= 0;
         memAV3 <= 0;
         memAV4 <= 0;
         memAV5 <= 0;
         NEXT_STATE_DC <= DR_1_3;
        end
        else if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==1 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
         wEN <= 1;
         addr <= AR_3;
         DR_OUT <= DR_3;
         memAV1 <= 0;
         memAV2 <= 0;
         memAV3 <= 0;
         memAV4 <= 0;
         NEXT_STATE_DC <= DR_1_3;
        end
        else if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==1 && coreS_5==1 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
         wEN <= 1;
         addr <= AR_3;
         DR_OUT <= DR_3;
         memAV1 <= 1;
         memAV2 <= 1;
         memAV3 <= 1;
         NEXT_STATE_DC <= NORM;
        end        
      end

      DR_1_3:begin
        if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==0) begin
         wEN <= 1;
         addr <= AR_4;
         DR_OUT <= DR_4;
         memAV1 <= 0;
         memAV2 <= 0;
         memAV3 <= 0;
         memAV4 <= 0;
         memAV5 <= 0;
         memAV6 <= 0;
         memAV7 <= 0;
         memAV8 <= 0;

         NEXT_STATE_DC <= DR_1_4;
        end
        else if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==1) begin
         wEN <= 1;
         addr <= AR_4;
         DR_OUT <= DR_4;
         memAV1 <= 0;
         memAV2 <= 0;
         memAV3 <= 0;
         memAV4 <= 0;
         memAV5 <= 0;
         memAV6 <= 0;
         memAV7 <= 0;
         NEXT_STATE_DC <= DR_1_4;
        end
        else if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==1 && coreS_8==1) begin
         wEN <= 1;
         addr <= AR_4;
         DR_OUT <= DR_4;
         memAV1 <= 0;
         memAV2 <= 0;
         memAV3 <= 0;
         memAV4 <= 0;
         memAV5 <= 0;
         memAV6 <= 0;
         NEXT_STATE_DC <= DR_1_4;
        end
        else if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
         wEN <= 1;
         addr <= AR_4;
         DR_OUT <= DR_4;
         memAV1 <= 0;
         memAV2 <= 0;
         memAV3 <= 0;
         memAV4 <= 0;
         memAV5 <= 0;
         NEXT_STATE_DC <= DR_1_4;
        end
        else if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==1 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
         wEN <= 1;
         addr <= AR_4;
         DR_OUT <= DR_4;
         memAV1 <= 1;
         memAV2 <= 1;
         memAV3 <= 1;
         memAV4 <= 1;
         NEXT_STATE_DC <= NORM;
        end
      end

      DR_1_4:begin
        if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==0) begin
         wEN <= 1;
         addr <= AR_5;
         DR_OUT <= DR_5;
         memAV1 <= 0;
         memAV2 <= 0;
         memAV3 <= 0;
         memAV4 <= 0;
         memAV5 <= 0;
         memAV6 <= 0;
         memAV7 <= 0;
         memAV8 <= 0;

         NEXT_STATE_DC <= DR_1_5;
        end
        else if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==1) begin
         wEN <= 1;
         addr <= AR_5;
         DR_OUT <= DR_5;
         memAV1 <= 0;
         memAV2 <= 0;
         memAV3 <= 0;
         memAV4 <= 0;
         memAV5 <= 0;
         memAV6 <= 0;
         memAV7 <= 0;
         NEXT_STATE_DC <= DR_1_5;
        end
        else if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==1 && coreS_8==1) begin
         wEN <= 1;
         addr <= AR_5;
         DR_OUT <= DR_5;
         memAV1 <= 0;
         memAV2 <= 0;
         memAV3 <= 0;
         memAV4 <= 0;
         memAV5 <= 0;
         memAV6 <= 0;
         NEXT_STATE_DC <= DR_1_5;
        end
        else if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==1 && coreS_7==1 && coreS_8==1) begin
         wEN <= 1;
         addr <= AR_5;
         DR_OUT <= DR_5;
         memAV1 <= 1;
         memAV2 <= 1;
         memAV3 <= 1;
         memAV4 <= 1;
         memAV5 <= 1;
         NEXT_STATE_DC <= NORM;
        end
      end
    DR_1_5:begin
        if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==0) begin
         wEN <= 1;
         addr <= AR_6;
         DR_OUT <= DR_6;
         memAV1 <= 0;
         memAV2 <= 0;
         memAV3 <= 0;
         memAV4 <= 0;
         memAV5 <= 0;
         memAV6 <= 0;
         memAV7 <= 0;
         memAV8 <= 0;

         NEXT_STATE_DC <= DR_1_6;
        end
        else if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==1) begin
         wEN <= 1;
         addr <= AR_6;
         DR_OUT <= DR_6;
         memAV1 <= 0;
         memAV2 <= 0;
         memAV3 <= 0;
         memAV4 <= 0;
         memAV5 <= 0;
         memAV6 <= 0;
         memAV7 <= 0;
         NEXT_STATE_DC <= DR_1_6;
        end
        else if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==1 && coreS_8==1) begin
         wEN <= 1;
         addr <= AR_6;
         DR_OUT <= DR_6;
         memAV1 <= 1;
         memAV2 <= 1;
         memAV3 <= 1;
         memAV4 <= 1;
         memAV5 <= 1;
         memAV6 <= 1;
         NEXT_STATE_DC <= NORM;
        end
      end

    DR_1_6:begin
        if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==0) begin
         wEN <= 1;
         addr <= AR_7;
         DR_OUT <= DR_7;
         memAV1 <= 0;
         memAV2 <= 0;
         memAV3 <= 0;
         memAV4 <= 0;
         memAV5 <= 0;
         memAV6 <= 0;
         memAV7 <= 0;
         memAV8 <= 0;

         NEXT_STATE_DC <= DR_1_7;
        end
        else if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==1) begin
         wEN <= 1;
         addr <= AR_7;
         DR_OUT <= DR_7;
         memAV1 <= 1;
         memAV2 <= 1;
         memAV3 <= 1;
         memAV4 <= 1;
         memAV5 <= 1;
         memAV6 <= 1;
         memAV7 <= 1;
         NEXT_STATE_DC <= NORM;
        end
        
      end
    DR_1_7:begin
        if(coreS_1==0 && coreS_2==0 && coreS_3==0 && coreS_4==0 && coreS_5==0 && coreS_6==0 && coreS_7==0 && coreS_8==0) begin
         wEN <= 1;
         addr <= AR_8;
         DR_OUT <= DR_8;
         memAV1 <= 1;
         memAV2 <= 1;
         memAV3 <= 1;
         memAV4 <= 1;
         memAV5 <= 1;
         memAV6 <= 1;
         memAV7 <= 1;
         memAV8 <= 1;

         NEXT_STATE_DC <= NORM;
        end
      end



    endcase
    
end



endmodule


