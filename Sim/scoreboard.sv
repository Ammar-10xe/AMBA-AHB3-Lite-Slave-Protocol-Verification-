`include "amba_ahb_defines.sv"

class scoreboard;
  mailbox mon2scb;
  int     no_transaction;
  int     hport_data_access = 1; //for testing purpose 
  bit     big_endian;        // 0 means little endian else big endian (default value == 0)
  logic   [`HLOCAL_MEM-1:0] local_memory [0:255]; //256B Byte accessible local memory
  bit     [31:0] local_read_byte,local_read_halfword,local_read_word;

  //constructor 
  function new(mailbox mon2scb);
    this.mon2scb = mon2scb;
  endfunction

  task IDLE_transfer(transaction trans);
    if (trans.HRESP == `H_OKAY) begin
      $display("\033[37m✓ \033[1;32mTest Passed\033[0m - IDLE transfer - No data transfer is required");
    end
    else begin
      $display("\033[37m✘ \033[1;31mTest Failed\033[0m - Invalid transfer type for IDLE state - No data transfer is required");
    end
  endtask

  task BUSY_transfer(transaction trans);
    if (trans.HRESP == `H_OKAY) begin
      $display("\033[37m✓ \033[1;32mTest Passed\033[0m - Slave provides zero wait state OKAY response to BUSY transfer");
    end
    else begin
      $display("\033[37m✘ \033[1;31mTest Failed\033[0m - Slave does not provide zero wait state OKAY response to BUSY transfer");
    end
  endtask

  task write_operation(transaction trans); //Write Access
    case (trans.HSIZE)
      `H_SIZE_8 : begin //Byte Case
        case (trans.HADDR[1:0])

          2'b00 :begin
            if (~big_endian) begin //little Endian -Byte0
              $display("╭────────────────────────────╮");
              $display("│   LITTLE ENDIAN BYTE[0]    │");
              $display("╰────────────────────────────╯");
              local_memory[trans.HADDR] = trans.HWDATA[7:0];
              #1; // Introducing a delay to ensure assignment has taken effect
              if (trans.HWDATA[7:0] == local_memory[trans.HADDR]) begin
                $display("\033[1;32m✓ Test Passed\033[0m - write data verification successful");
              end
              else begin //Big Endian
                $display("\033[1;31m✘ Test Failed\033[0m - write data verification failed");
              end
                $display("At address \033[34m%h\033[0m, Expected \033[34m%h\033[0m, of HWDATA \033[34m%h\033[0m, Got \033[34m%h\033[0m", trans.HADDR, trans.HWDATA[7:0],trans.HWDATA, local_memory[trans.HADDR]);
            end

            else begin
              $display("╭────────────────────────────╮");
              $display("│    BIG ENDIAN BYTE[0]      │");
              $display("╰────────────────────────────╯");              
              local_memory[trans.HADDR] = trans.HWDATA[31:24]; //Big Endian -Byte0
              #1; // Introducing a delay to ensure assignment has taken effect
              if (trans.HWDATA[31:24] == local_memory[trans.HADDR]) begin
                $display("\033[1;32m✓ Test Passed\033[0m - write data verification successful");
              end 
              else begin //Big Endian
                $display("\033[1;31m✘ Test Failed\033[0m - write data verification failed");
              end
                $display("At address \033[34m%h\033[0m, Expected \033[34m%h\033[0m, of HWDATA \033[34m%h\033[0m, Got \033[34m%h\033[0m", trans.HADDR, trans.HWDATA[31:24],trans.HWDATA, local_memory[trans.HADDR]);
            end

          end 

          2'b01 :begin 
            if (~big_endian) begin //little Endian -Byte1
              $display("╭────────────────────────────╮");
              $display("│   LITTLE ENDIAN BYTE[1]    │");
              $display("╰────────────────────────────╯");            
              local_memory[trans.HADDR] = trans.HWDATA[15:8];
              #1; // Introducing a delay to ensure assignment has taken effect
              if (trans.HWDATA[15:8] == local_memory[trans.HADDR]) begin
                $display("\033[1;32m✓ Test Passed\033[0m - write data verification successful");
              end
              else begin //Big Endian
                $display("\033[1;31m✘ Test Failed\033[0m - write data verification failed");
              end
                $display("At address \033[34m%h\033[0m, Expected \033[34m%h\033[0m, of HWDATA \033[34m%h\033[0m, Got \033[34m%h\033[0m", trans.HADDR, trans.HWDATA[15:8],trans.HWDATA, local_memory[trans.HADDR]);
            end

            else begin
              $display("╭────────────────────────────╮");
              $display("│    BIG ENDIAN BYTE[1]      │");
              $display("╰────────────────────────────╯");                
              local_memory[trans.HADDR] = trans.HWDATA[23:16]; //Big Endian -Byte0
              #1; // Introducing a delay to ensure assignment has taken effect
              if (trans.HWDATA[23:16] == local_memory[trans.HADDR]) begin
                $display("\033[1;32m✓ Test Passed\033[0m - write data verification successful");
              end 
              else begin //Big Endian
                $display("\033[1;31m✘ Test Failed\033[0m - write data verification failed");
              end
                $display("At address \033[34m%h\033[0m, Expected \033[34m%h\033[0m, of HWDATA \033[34m%h\033[0m, Got \033[34m%h\033[0m", trans.HADDR, trans.HWDATA[23:16],trans.HWDATA, local_memory[trans.HADDR]);
            end
          end

          2'b10 :begin            
            if (~big_endian) begin //little Endian -Byte2
              $display("╭────────────────────────────╮");
              $display("│   LITTLE ENDIAN BYTE[2]    │");
              $display("╰────────────────────────────╯");            
              local_memory[trans.HADDR] = trans.HWDATA[23:16];
              #1; // Introducing a delay to ensure assignment has taken effect
              if (trans.HWDATA[23:16] == local_memory[trans.HADDR]) begin
                $display("\033[1;32m✓ Test Passed\033[0m - write data verification successful");
              end
              else begin //Big Endian
                $display("\033[1;31m✘ Test Failed\033[0m - write data verification failed");
              end
                $display("At address \033[34m%h\033[0m, Expected \033[34m%h\033[0m, of HWDATA \033[34m%h\033[0m, Got \033[34m%h\033[0m", trans.HADDR, trans.HWDATA[23:16],trans.HWDATA, local_memory[trans.HADDR]);
            end

            else begin
              $display("╭────────────────────────────╮");
              $display("│    BIG ENDIAN BYTE[2]      │");
              $display("╰────────────────────────────╯");                
              local_memory[trans.HADDR] = trans.HWDATA[15:8]; //Big Endian -Byte2
              #1; // Introducing a delay to ensure assignment has taken effect
              if (trans.HWDATA[15:8] == local_memory[trans.HADDR]) begin
                $display("\033[1;32m✓ Test Passed\033[0m - write data verification successful");
              end 
              else begin //Big Endian
                $display("\033[1;31m✘ Test Failed\033[0m - write data verification failed");
              end
                $display("At address \033[34m%h\033[0m, Expected \033[34m%h\033[0m, of HWDATA \033[34m%h\033[0m, Got \033[34m%h\033[0m", trans.HADDR, trans.HWDATA[15:8],trans.HWDATA, local_memory[trans.HADDR]);
            end
          end

          2'b11 : begin           
            if (~big_endian) begin //little Endian -Byte3
              $display("╭────────────────────────────╮");
              $display("│   LITTLE ENDIAN BYTE[3]    │");
              $display("╰────────────────────────────╯");             
              local_memory[trans.HADDR] = trans.HWDATA[31:24];
              #1; // Introducing a delay to ensure assignment has taken effect
              if (trans.HWDATA[31:24] == local_memory[trans.HADDR]) begin
                $display("\033[1;32m✓ Test Passed\033[0m - write data verification successful");
              end
              else begin //Big Endian
                $display("\033[1;31m✘ Test Failed\033[0m - write data verification failed");
              end
                $display("At address \033[34m%h\033[0m, Expected \033[34m%h\033[0m, of HWDATA \033[34m%h\033[0m, Got \033[34m%h\033[0m", trans.HADDR, trans.HWDATA[31:24],trans.HWDATA, local_memory[trans.HADDR]);
            end

            else begin
              $display("╭────────────────────────────╮");
              $display("│    BIG ENDIAN BYTE[3]      │");
              $display("╰────────────────────────────╯");                
              local_memory[trans.HADDR] = trans.HWDATA[7:0]; //Big Endian -Byte3
              #1; // Introducing a delay to ensure assignment has taken effect
              if (trans.HWDATA[7:0] == local_memory[trans.HADDR]) begin
                $display("\033[1;32m✓ Test Passed\033[0m - write data verification successful");
              end 
              else begin //Big Endian
                $display("\033[1;31m✘ Test Failed\033[0m - write data verification failed");
              end
                $display("At address \033[34m%h\033[0m, Expected \033[34m%h\033[0m, of HWDATA \033[34m%h\033[0m, Got \033[34m%h\033[0m", trans.HADDR, trans.HWDATA[7:0],trans.HWDATA, local_memory[trans.HADDR]);
            end
          end
       endcase 
     end 

//For Halfword Big ENDIAN Test would fail because the dut is using Little Endian 

      `H_SIZE_16: begin // Halfword Case
        case (trans.HADDR[1])      
          1'b0: begin
            if (~big_endian) begin //little Endian Halfword 0
              $display("╭────────────────────────────╮");
              $display("│  LITTLE ENDIAN HALFWORD[0] │");
              $display("╰────────────────────────────╯");              
              // local_memory[trans.HADDR     ] = trans.HWDATA[7:0 ];
              // local_memory[trans.HADDR + 1 ] = trans.HWDATA[15:8];
              local_memory[trans.HADDR] = {trans.HWDATA[15:8], trans.HWDATA[7:0]};
              
              #1; // Introducing a delay to ensure assignment has taken effect
              if (trans.HWDATA[15:0] == local_memory[trans.HADDR]) begin
                $display("\033[1;32m✓ Test Passed\033[0m  -  write data verification successful");
              end else begin
                $display("\033[1;31m✘ Test Failed\033[0m  -  write data verification failed");
              end
                $display("At address \033[34m%h\033[0m, Expected \033[34m%h\033[0m, of HWDATA \033[34m%h\033[0m, Got \033[34m%h\033[0m", trans.HADDR, trans.HWDATA[15:0],trans.HWDATA, local_memory[trans.HADDR]);
            end

            else begin //Big Endian Halfword 0
              $display("╭────────────────────────────╮");
              $display("│   BIG ENDIAN HALFWORD[0]   │");
              $display("╰────────────────────────────╯");              
              // local_memory[trans.HADDR     ] = trans.HWDATA[15:8];
              // local_memory[trans.HADDR + 1 ] = trans.HWDATA[7:0 ];

              local_memory[trans.HADDR] = {trans.HWDATA[7:0], trans.HWDATA[15:8]};
              
              #1; // Introducing a delay to ensure assignment has taken effect
              if (trans.HWDATA[15:0] == local_memory[trans.HADDR]) begin
                $display("\033[1;32m✓ Test Passed\033[0m  -  write data verification successful");
              end else begin
                $display("\033[1;31m✘ Test Failed\033[0m  -  write data verification failed");
              end
                $display("At address \033[34m%h\033[0m, Expected \033[34m%h\033[0m, of HWDATA \033[34m%h\033[0m, Got \033[34m%h\033[0m", trans.HADDR, trans.HWDATA[15:0],trans.HWDATA, local_memory[trans.HADDR]);
            end
          end

          1'b1: begin              
            if (~big_endian) begin //little Endian Halfword 1
              $display("╭────────────────────────────╮");
              $display("│  LITTLE ENDIAN HALFWORD[1] │");
              $display("╰────────────────────────────╯");             
              // local_memory[trans.HADDR + 2    ] = trans.HWDATA[23:16];
              // local_memory[trans.HADDR + 3    ] = trans.HWDATA[31:24];
              local_memory[trans.HADDR] = {trans.HWDATA[31:24], trans.HWDATA[23:16]}; 
              
              #1; // Introducing a delay to ensure assignment has taken effect
              if (trans.HWDATA[31:16] == local_memory[trans.HADDR]) begin
                $display("\033[1;32m✓ Test Passed\033[0m  -  write data verification successful");
              end
              else begin
                $display("\033[1;31m✘ Test Failed\033[0m  -  write data verification failed");
              end
                $display("At address \033[34m%h\033[0m, Expected \033[34m%h\033[0m, of HWDATA \033[34m%h\033[0m, Got \033[34m%h\033[0m", trans.HADDR, trans.HWDATA[31:16],trans.HWDATA, local_memory[trans.HADDR]);
            end

            else begin //Big Endian Halfword 1
              $display("╭────────────────────────────╮");
              $display("│   BIG ENDIAN HALFWORD[1]   │");
              $display("╰────────────────────────────╯");             
              // local_memory[trans.HADDR + 2 ] = trans.HWDATA[31:24];
              // local_memory[trans.HADDR + 3 ] = trans.HWDATA[23:16];
              local_memory[trans.HADDR] = {trans.HWDATA[23:16], trans.HWDATA[31:24]}; 
              
              #1; // Introducing a delay to ensure assignment has taken effect
              if (trans.HWDATA[31:16] == local_memory[trans.HADDR]) begin
                $display("\033[1;32m✓ Test Passed\033[0m  -  write data verification successful");
              end 
              else begin
                $display("\033[1;31m✘ Test Failed\033[0m  -  write data verification failed");
              end
                $display("At address \033[34m%h\033[0m, Expected \033[34m%h\033[0m, of HWDATA \033[34m%h\033[0m, Got \033[34m%h\033[0m", trans.HADDR, trans.HWDATA[31:16],trans.HWDATA, local_memory[trans.HADDR]);
            end
          end
        endcase
      end

      `H_SIZE_32: begin // Word Case
        if (~big_endian) begin //little endian (LSB at lowset address)
          $display("╭────────────────────────────╮");
          $display("│     LITTLE ENDIAN WORD     │");
          $display("╰────────────────────────────╯");  
          // local_memory[trans.HADDR     ] = trans.HWDATA[7:0  ];
          // local_memory[trans.HADDR + 1 ] = trans.HWDATA[15:8 ];
          // local_memory[trans.HADDR + 2 ] = trans.HWDATA[23:16];
          // local_memory[trans.HADDR + 3 ] = trans.HWDATA[31:24];
          local_memory[trans.HADDR] = trans.HWDATA;
          #1; // Introducing a delay to ensure assignment has taken effect
          if (trans.HWDATA == local_memory[trans.HADDR]) begin
            $display("\033[37m✓ \033[1;32mTest Passed\033[0m - write data verification successful");
          end else begin
            $display("\033[37m✘ \033[1;31mTest Failed\033[0m - write data verification failed");
          end
            $display("At address \033[34m%h\033[0m, Expected \033[34m%h\033[0m, Got \033[34m%h\033[0m", trans.HADDR,trans.HWDATA[31:0],local_memory[trans.HADDR]);
        end
        else begin  // Big endian
          $display("╭────────────────────────────╮");
          $display("│       BIG ENDIAN WORD      │");
          $display("╰────────────────────────────╯"); 
          // local_memory[trans.HADDR     ] = trans.HWDATA[31:24];
          // local_memory[trans.HADDR + 1 ] = trans.HWDATA[23:16];
          // local_memory[trans.HADDR + 2 ] = trans.HWDATA[15:8 ];
          // local_memory[trans.HADDR + 3 ] = trans.HWDATA[7:0  ];
           local_memory[trans.HADDR] = {trans.HWDATA[7:0],trans.HWDATA[15:8],trans.HWDATA[23:16], trans.HWDATA[31:24]};
          #1; // Introducing a delay to ensure assignment has taken effect
          if (trans.HWDATA == `Big_Endian_Word) begin
            $display("\033[37m✓ \033[1;32mTest Passed\033[0m - write data verification successful");
          end else begin
            $display("\033[37m✘ \033[1;31mTest Failed\033[0m - write data verification failed");
          end
          $display("At address \033[34m%h\033[0m, Expected \033[34m%h\033[0m, Got \033[34m%h\033[0m", trans.HADDR,trans.HWDATA[31:0],local_memory[trans.HADDR]);
        end
      end
    endcase 
  endtask

  task read_operation(transaction trans); //For Read Access
    case (trans.HSIZE)
      
      `H_SIZE_8 : begin //Byte Case
        case (trans.HADDR[1:0])
          2'b00 : begin
            $display("╭────────────────────────────╮");
            $display("│   LITTLE ENDIAN BYTE[0]    │");
            $display("╰────────────────────────────╯");            
            local_read_byte = local_memory[trans.HADDR[31:2]][7:0];
            #1;
            if ( trans.HRDATA[7:0] == local_read_byte)begin
              $display("\033[37m✓ \033[1;32mTest Passed\033[0m - Read data verification successful");
              end
            else begin
              $display("\033[37m✘ \033[1;31mTest Failed\033[0m - Read data verification failed");
            end
            $display("At address \033[34m%h\033[0m, Expected \033[34m%h\033[0m, Got \033[34m%h\033[0m", trans.HADDR,trans.HRDATA[7:0],local_memory[trans.HADDR[31:2]][7:0]);
          end 
          2'b01 : begin
            $display("╭────────────────────────────╮");
            $display("│   LITTLE ENDIAN BYTE[1]    │");
            $display("╰────────────────────────────╯");               
            local_read_byte = local_memory[trans.HADDR[31:2]][15:8];
            #1;
            if ( trans.HRDATA[15:8] == local_read_byte)begin
              $display("\033[37m✓ \033[1;32mTest Passed\033[0m - Read data verification successful");
              end
            else begin
              $display("\033[37m✘ \033[1;31mTest Failed\033[0m - Read data verification failed");
            end
            $display("At address \033[34m%h\033[0m, Expected \033[34m%h\033[0m, Got \033[34m%h\033[0m", trans.HADDR,trans.HRDATA[15:8],local_memory[trans.HADDR[31:2]][15:8]);
          end 
          2'b10 : begin
            $display("╭────────────────────────────╮");
            $display("│   LITTLE ENDIAN BYTE[2]    │");
            $display("╰────────────────────────────╯");               
            local_read_byte = local_memory[trans.HADDR[31:2]][23:16];
            #1;
            if ( trans.HRDATA[23:16] == local_read_byte)begin
              $display("\033[37m✓ \033[1;32mTest Passed\033[0m - Read data verification successful");
              end
            else begin
              $display("\033[37m✘ \033[1;31mTest Failed\033[0m - Read data verification failed");
            end
            $display("At address \033[34m%h\033[0m, Expected \033[34m%h\033[0m, Got \033[34m%h\033[0m", trans.HADDR,trans.HRDATA[23:16],local_memory[trans.HADDR[31:2]][23:16]);
          end
          2'b11 : begin
            $display("╭────────────────────────────╮");
            $display("│   LITTLE ENDIAN BYTE[3]    │");
            $display("╰────────────────────────────╯");               
            local_read_byte = local_memory[trans.HADDR[31:2]][31:24];
            #1;
            if ( trans.HRDATA[31:24] == local_read_byte)begin
              $display("\033[37m✓ \033[1;32mTest Passed\033[0m - Read data verification successful");
              end
            else begin
              $display("\033[37m✘ \033[1;31mTest Failed\033[0m - Read data verification failed");
            end
            $display("At address \033[34m%h\033[0m, Expected \033[34m%h\033[0m, Got \033[34m%h\033[0m", trans.HADDR,trans.HRDATA[31:24],local_memory[trans.HADDR[31:2]][31:24]);
          end
        endcase 
      end

      `H_SIZE_16: begin //Halfword Case
        case (trans.HADDR[1])
          1'b0 : begin
            $display("╭────────────────────────────╮");
            $display("│  LITTLE ENDIAN HALFWORD[0] │");
            $display("╰────────────────────────────╯");             
            local_read_halfword = local_memory[trans.HADDR[31:2]][15:0];
            #1;
            if ( trans.HRDATA[15:0] == local_read_halfword)begin
              $display("\033[37m✓ \033[1;32mTest Passed\033[0m - Read data verification successful");
              end
            else begin
              $display("\033[37m✘ \033[1;31mTest Failed\033[0m - Read data verification failed");
            end
            $display("At address \033[34m%h\033[0m, Expected \033[34m%h\033[0m, Got \033[34m%h\033[0m", trans.HADDR,trans.HRDATA[15:0],local_memory[trans.HADDR[31:2]][15:0]);
          end
          1'b1 : begin
            $display("╭────────────────────────────╮");
            $display("│  LITTLE ENDIAN HALFWORD[1] │");
            $display("╰────────────────────────────╯");              
            local_read_halfword = local_memory[trans.HADDR[31:2]][31:16];
            #1;
            if ( trans.HRDATA[31:16] == local_read_halfword)begin
              $display("\033[37m✓ \033[1;32mTest Passed\033[0m - Read data verification successful");
              end
            else begin
              $display("\033[37m✘ \033[1;31mTest Failed\033[0m - Read data verification failed");
            end
            $display("At address \033[34m%h\033[0m, Expected \033[34m%h\033[0m, Got \033[34m%h\033[0m", trans.HADDR,trans.HRDATA[31:16],local_memory[trans.HADDR[31:2]][31:16]);  
          end
        endcase
      end    

      `H_SIZE_32 : begin //word Case
         $display("╭────────────────────────────╮");
         $display("│     LITTLE ENDIAN WORD     │");
         $display("╰────────────────────────────╯");       
         local_read_word  = local_memory[trans.HADDR[31:2]];
         #1;
          if ( trans.HRDATA == local_read_word)begin
            $display("\033[37m✓ \033[1;32mTest Passed\033[0m - Read data verification successful");
            end
          else begin
            $display("\033[37m✘ \033[1;31mTest Failed\033[0m - Read data verification failed");
          end
          $display("At address \033[34m%h\033[0m, Expected \033[34m%h\033[0m, Got \033[34m%h\033[0m", trans.HADDR,trans.HRDATA,local_memory[trans.HADDR[31:2]]);
        end
        
    endcase
  endtask


  task main();
    transaction trans;
    forever begin
     $display("╔════════════════════════════════════════╗");
     $display("║       [SCOREBOARD-TRANSFER:  %0d]       ║", no_transaction);
     $display("╚════════════════════════════════════════╝");
      mon2scb.get(trans);
      if (trans.HREADY == `H_READY) begin                               //checks the HREADY response
        $display("\033[37m✓ \033[1;32mTest Passed\033[0m - Ready for the next transfer");
        if (trans.HSEL ==`H_SLAVE_SELECT) begin                         //checks slave is connected or not  
          $display("\033[37m✓ \033[1;32mTest Passed\033[0m - Slave is connected");      
          if (trans.HPROT[0] == `HPROT_DATA ) begin                     //checks protection for data access only
            $display("\033[37m✓ \033[1;32mTest Passed\033[0m - Protection control for data access only");
            if (hport_data_access) begin                                           
              if      (trans.HTRANS == `H_IDLE)   IDLE_transfer(trans);   //check for the idle response   
              else if (trans.HTRANS == `H_BUSY)   BUSY_transfer(trans);   //checks for the busy response
              else if (trans.HTRANS == `H_SEQ )   begin
                  if      (trans.HWRITE == `H_WRITE ) write_operation(trans);
                  else if (trans.HWRITE == `H_READ  ) read_operation(trans);
              end   
              else if     (trans.HTRANS == `H_NONSEQ) begin
                  if      (trans.HWRITE == `H_WRITE ) write_operation(trans);
                  else if (trans.HWRITE == `H_READ  ) read_operation(trans);
              end
            end
            else $display("  ✘ Protection control is not for data access - Test Failed");
          end
          if (trans.HBURST == `H_SINGLE | `H_WRAP4 | `H_INCR4) begin
            if (trans.HBURST == `H_SINGLE) begin
              if      (trans.HWRITE == `H_WRITE ) write_operation(trans);
              else if (trans.HWRITE == `H_READ  ) read_operation(trans);  
              $display("\033[37m✓ \033[1;32mTest Passed\033[0m - Single transfer burst "); 
            end
            else if (trans.HBURST == `H_WRAP4) begin
              if      (trans.HWRITE == `H_WRITE ) write_operation(trans);
              else if (trans.HWRITE == `H_READ  ) read_operation(trans);   
              $display("\033[37m✓ \033[1;32mTest Passed\033[0m - 4-beat wrapping burst ");
            end
            else if (trans.HBURST == `H_INCR4) begin
              if      (trans.HWRITE == `H_WRITE ) write_operation(trans);
              else if (trans.HWRITE == `H_READ  ) read_operation(trans);                 
              $display("\033[37m✓ \033[1;32mTest Passed\033[0m - 4-beat incrementing burst ");                 
            end
            else begin
            $display("  ✘ HBURST is arbitrary - Test Failed");
            end 
          end   
        end
        no_transaction++;
      end
        
      else begin
        if (trans.HREADY == `H_NOT_READY | trans.HSEL == `H_NO_SLAVE_SELECT )
          $display("⌛\033[1;31m Slave needs extra time to sample data\033[0m");
          $display("⚠ \033[1;31m Slave is not connected\033[0m");
         no_transaction++;
      end

  end
  
  endtask
  
endclass
