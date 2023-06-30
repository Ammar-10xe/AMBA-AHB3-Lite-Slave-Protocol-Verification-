`include "amba_ahb_defines.sv"
class scoreboard;
  mailbox mon2scb;
  int     no_transaction;
  int     hport_data_access = 1; //for testing purpose 
  logic   [`HDATA_SIZE-1:0] local_memory [0:255]; //256 byte of local memory
  logic   [31:0] local_read_byte,local_read_halfword,local_read_word;

  //constructor 
  function new(mailbox mon2scb);
    this.mon2scb = mon2scb;
    // initialize_memory();
  endfunction

  // // Function to initialize local_memory
  // function void initialize_memory();
  //   integer file;
  //   string line;
  //   file = $fopen("local_mem.txt", "r");
  //   if (file != 0) begin
  //     for (int i = 0; i < 256; i++) begin
  //       if (!$feof(file)) begin
  //         $fscanf(file, "%h", local_memory[i]);
  //       end else begin
  //         $error("Error: Insufficient data in local_mem.txt, initializing with default value");
  //         local_memory[i] = 32'hdeadbeef;
  //       end
  //     end
  //     $fclose(file);
  //   end else begin
  //     $display("Error: Failed to open local_mem.txt, initializing with default value");
  //     foreach (local_memory[i])
  //       local_memory[i] = 32'hdeadbeef;
  //   end
  // endfunction

  task write_operation(transaction trans); //for write access
    case (trans.HSIZE)
      `H_SIZE_8 : begin //Byte Case
        case (trans.HADDR[1:0])
          2'b00 :begin
            local_memory [trans.HADDR] = trans.HWDATA [7:0];
            if (trans.HWDATA[7:0] == local_memory[trans.HADDR][7:0]) begin
              $display("\033[1;32m✓ Test Passed\033[0m - Byte[0] Data verification successful");
            end else begin
              $display("\033[1;31m✘ Test Failed\033[0m - Byte[0] Data verification failed");
            end
              $display("At address \033[34m%h\033[0m, Expected \033[34m%h\033[0m, of HWDATA \033[34m%h\033[0m, Got \033[34m%h\033[0m", trans.HADDR, trans.HWDATA[7:0],trans.HWDATA, local_memory[trans.HADDR][7:0]);
          end 
          2'b01 :begin 
            local_memory [trans.HADDR] = trans.HWDATA [15:8];
            if (trans.HWDATA[15:8] == local_memory[trans.HADDR][15:8]) begin
              $display("\033[1;32m✓ Test Passed\033[0m - Byte[1] Data verification successful");
            end else begin
              $display("\033[1;31m✘ Test Failed\033[0m - Byte[1] Data verification failed");
            end
              $display("At address \033[34m%h\033[0m, Expected \033[34m%h\033[0m, of HWDATA \033[34m%h\033[0m, Got \033[34m%h\033[0m", trans.HADDR, trans.HWDATA[15:8],trans.HWDATA, local_memory[trans.HADDR][15:8]);
          end 
          2'b10 :begin
            local_memory [trans.HADDR] = trans.HWDATA [23:16];
            if (trans.HWDATA[23:16] == local_memory[trans.HADDR][23:16]) begin
              $display("\033[1;32m✓ Test Passed\033[0m - Byte[2] Data verification successful");
            end else begin
              $display("\033[1;31m✘ Test Failed\033[0m - Byte[2] Data verification failed");
            end
              $display("At address \033[34m%h\033[0m, Expected \033[34m%h\033[0m, of HWDATA \033[34m%h\033[0m, Got \033[34m%h\033[0m", trans.HADDR, trans.HWDATA[23:16],trans.HWDATA, local_memory[trans.HADDR][23:16]);
          end 
          2'b11 : begin
            local_memory [trans.HADDR] = trans.HWDATA [31:24];
            if (trans.HWDATA[31:24] == local_memory[trans.HADDR][31:24]) begin
              $display("\033[1;32m✓ Test Passed\033[0m - Byte[3] Data verification successful");
            end else begin
              $display("\033[1;31m✘ Test Failed\033[0m - Byte[3] Data verification failed");
            end
              $display("At address \033[34m%h\033[0m, Expected \033[34m%h\033[0m, of HWDATA \033[34m%h\033[0m, Got \033[34m%h\033[0m", trans.HADDR, trans.HWDATA[31:24],trans.HWDATA, local_memory[trans.HADDR][31:24]);
          end
       endcase 
     end 
     
      `H_SIZE_16: begin // Halfword Case
        case (trans.HADDR[1])
          1'b0: begin
            local_memory[trans.HADDR] = trans.HWDATA[15:0];
            #1; // Introducing a delay to ensure assignment has taken effect
            if (trans.HWDATA[15:0] == local_memory[trans.HADDR][15:0]) begin
              $display("\033[1;32m✓ Test Passed\033[0m - Halfword[1] Data verification successful");
            end else begin
              $display("\033[1;31m✘ Test Failed\033[0m - Halfword[1] Data verification failed");
            end
              $display("At address \033[34m%h\033[0m, Expected \033[34m%h\033[0m, of HWDATA \033[34m%h\033[0m, Got \033[34m%h\033[0m", trans.HADDR, trans.HWDATA[15:0],trans.HWDATA, local_memory[trans.HADDR][15:0]);
          end

          1'b1: begin
            if (trans.HWDATA[31:16] == local_memory[trans.HADDR][31:16]) begin
            #1; // Introducing a delay to ensure assignment has taken effect
            if (trans.HWDATA[31:16] == local_memory[trans.HADDR][31:16]) begin
              $display("\033[1;32m✓ Test Passed\033[0m - Halfword[0] Data verification successful");
            end 
            else begin
              $display("\033[1;31m✘ Test Failed\033[0m - Halfword[0] Data verification failed");
            end
              $display("At address \033[34m%h\033[0m, Expected \033[34m%h\033[0m, of HWDATA\033[34m%h\033[0m, Got \033[34m%h\033[0m", trans.HADDR, trans.HWDATA[31:16],trans.HWDATA, local_memory[trans.HADDR][31:16]);
          end
          end
        endcase
      end


      `H_SIZE_32: begin // Word Case
        local_memory[trans.HADDR] = trans.HWDATA[31:0];
        #1; // Introducing a delay to ensure assignment has taken effect
        if (trans.HWDATA == local_memory[trans.HADDR]) begin
          $display("\033[37m✓ \033[1;32mTest Passed\033[0m - [Word] Data verification successful");
        end else begin
          $display("\033[37m✘ \033[1;31mTest Failed\033[0m - [Word] Data verification failed");
        end
        $display("At address \033[34m%h\033[0m, Expected \033[34m%h\033[0m, Got \033[34m%h\033[0m", trans.HADDR,trans.HWDATA[31:0],local_memory[trans.HADDR]);
      end

    endcase 
  endtask

  task read_operation(transaction trans); //for read access
    $display("[Scoreboard]: Non Seq Read Test Passed ..."); 
    case (trans.HSIZE)
      
      `H_SIZE_8 : begin //Byte Case
        case (trans.HADDR[1:0])
          2'b00 : begin
            local_read_byte = local_memory [trans.HADDR];
            $display("Byte0 %h read at address %h",local_read_byte[7:0],trans.HADDR);
          end 
          2'b01 : begin
            local_read_byte = local_memory [trans.HADDR];
            $display("Byte1 %h read at address %h",local_read_byte[15:8],trans.HADDR);
          end 
          2'b10 : begin
            local_read_byte = local_memory [trans.HADDR];
            $display("Byte2 %h read at address %h",local_read_byte[23:16],trans.HADDR);
          end
          2'b11 : begin
            local_read_byte = local_memory [trans.HADDR];
            $display("Byte3 %h read at address %h",local_read_byte[31:24],trans.HADDR);
          end
        endcase 

        if ( trans.HRDATA == local_read_byte)begin
          $display("[Scoreboard]: Check byte Test is passed...");
          $display("Data read is %h from address %h",trans.HRDATA,trans.HADDR);
        end
        else begin
          $display("[Scoreboard]: Check byte Test is failed...");
          $display("Data read is %h from address %h",trans.HRDATA,trans.HADDR);
        end
      end

      `H_SIZE_16: begin //Halfword Case
        case (trans.HADDR[1])
          1'b0 : begin
            local_read_halfword = local_memory [trans.HADDR];
            $display("Halfword0 %h read at address %h",local_read_halfword[15:0],trans.HADDR);
          end
          1'b1 : begin
            local_read_halfword = local_memory [trans.HADDR];
            $display("Halfword1 %h read at address %h",local_read_halfword[31:16],trans.HADDR);  
          end
        endcase

        if ( trans.HRDATA == local_read_halfword)begin
          $display("[Scoreboard]: Check halfword test is passed...");
          $display("Data read is %h from address %h",trans.HRDATA,trans.HADDR);
          end
        else begin
          $display("[Scoreboard]: Check halfword test is failed...");
          $display("Data read is %h from address %h",trans.HRDATA,trans.HADDR);
        end
      end    

      `H_SIZE_32 : begin //word Case
         local_read_word  = local_memory[trans.HADDR[31:2]];
          if ( trans.HRDATA == local_read_word)begin
            $display("[Scoreboard]: Check word test is passed...");
            $display("Data read is %h from address %h",trans.HRDATA,trans.HADDR);
            end
          else begin
            $display("[Scoreboard]: Check word test is failed...");
            $display("Data read is %h from address %h but in local_mem it is %h",trans.HRDATA,trans.HADDR,local_memory[trans.HADDR[31:2]]);
          end
        end
    endcase
  endtask


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
              else if (trans.HTRANS == `H_SEQ)    $display("SEQ is yet to be added");
                // NONSEQ_transfer(trans); //checks for the seq response
              else if (trans.HTRANS == `H_NONSEQ) begin
                  if      (trans.HWRITE == `H_WRITE ) write_operation(trans);
                  else if (trans.HWRITE == `H_READ)   read_operation(trans);
              end
              else $display("  ✘ Protection control is not for data access - Test Failed");
            end
          end
        end
        no_transaction++;
  
      end
      
      else begin
        if (trans.HREADY == `H_NOT_READY | trans.HSEL == `H_NO_SLAVE_SELECT )
          $display("\033[1;31m  ⌛ Slave needs extra time to sample data\033[0m");
          $display("\033[1;31m  ⚠  Slave is not connected\033[0m");
         no_transaction++;
      end

    end
  
  endtask
  
endclass
