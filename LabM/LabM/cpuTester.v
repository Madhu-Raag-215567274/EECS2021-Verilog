module labM;
reg [31:0] PCin;
reg  RegWrite, clk, ALUSrc, MemRead, MemWrite, Mem2Reg;
reg [2:0] op;
wire [31:0] wd, rd1, rd2, imm, ins, PCp4, aluZ, memOut, wb;
wire [31:0] jTarget, branch;
wire zero;
wire [4:0] rs1, rs2, rd;
 
yIF myIF(ins, PCp4, PCin, clk);
yID myID(rd1, rd2, imm, jTarget, branch, ins, wd, RegWrite, clk);
yEX myEx(aluZ, zero, rd1, rd2, imm, op, ALUSrc);
yDM myDM(memOut, aluZ, rd2, clk, MemRead, MemWrite);
yWB myWB(wb, aluZ, memOut, Mem2Reg);
assign wd = wb;

initial
begin
        //------------------------------------Entry point
        PCin = 16'h28;

	
        //------------------------------------Run program
        repeat (44)
        begin
                //---------------------------------Fetch an ins
                clk = 1; #1;
               
                //---------------------------------Set control signals
                RegWrite = 0; ALUSrc = 1; op = 3'b010;
                MemRead = 0; MemWrite = 0; Mem2Reg = 0;
                if (ins[6:0] == 7'h33) //R-type
                begin
                        RegWrite = 1; ALUSrc = 0;
		                if (ins[14:12] == 3'b110)
                        begin						
						    op = 3'b001; //or
						    #1;
							// $display("or: rd1=%h", rd1);
							// $display("or: rd2=%h", rd2);
							// $display("or: wb=%h", wb);	
							// $display("or: wn=%h", ins[11:7]);	
                            							
							//#1 $display("R-type: z=%h", z);
						end
                end
                else if (ins[6:0] == 7'h3 || ins[6:0] == 7'h13) //I-Type and lw
                begin
				        ALUSrc = 1;
                        RegWrite = 1;
                end
				else
                if (ins[6:0] == 7'h63) //beq
                begin
                        op = 3'b110;
                        ALUSrc = 0;
						// #1 $display("Type: $signed(branch)=%b", branch);
						// $display("Type: imm=%b%b%b%b", ins[31], ins[7], ins[30:25], ins[11:8]);
                end
				else
                if (ins[6:0] == 7'h23) //sw
                begin
				        Mem2Reg = 0;
				        RegWrite = 0;
				        ALUSrc = 1;
                        MemRead = 0;
						MemWrite = 1;
						op = 3'b010;
						#10;
						// $display("sw: while writing");
						// $display("sw: memOut=%h", memOut);
						// $display("sw: clk=%d, MemRead=%d, MemWrite=%d", clk, MemRead, MemWrite);
						// $display("sw: rd1=%h", rd1);
					    // $display("sw: rd2=%h", rd2);
					    // $display("sw: wb=%h", wb);
						// $display("sw: aluZ=%h", aluZ);
						
						clk = 1;
						MemWrite = 0;
						MemRead = 1;
						#1;
						
						// $display("sw: while reading");
						// $display("sw: memOut=%h", memOut);
						// $display("sw: clk=%d, MemRead=%d, MemWrite=%d", clk, MemRead, MemWrite);
						// $display("sw: rd1=%h", rd1);
					    // $display("sw: rd2=%h", rd2);
					    // $display("sw: wb=%h", wb);
						// $display("sw: aluZ=%h", aluZ);
						// $display("sw: %h: rd1=%2d rd2=%2d z=%3d zero=%b wb=%2d", ins, rd1, rd2, aluZ, zero, wb);
                end
				
                if (ins[6:0] == 7'h3) //lw again
                begin
                        MemRead = 1;
                        Mem2Reg = 1;
						// #1
						// $display("lw: rd2=%h", rd2);
						// $display("lw: z=%h", z);
						// $display("lw: memOut=%h", memOut);
						// $display("lw: wd=%h", wd);
                end
               
                //---------------------------------Execute the ins               
                clk = 0; #1;
                
  		        // $display("ins[7:0]=%h", ins[7:0]);
				
			   
                //---------------------------------View results
                 $display("%h: rd1=%2d rd2=%2d aluZ=%3d zero=%b wb=%2d", ins, rd1, rd2, aluZ, zero, wb);
//                 $display("%h: rs1=%d, rs2=%d, rd=%d, rd1=%2d rd2=%2d aluZ=%3d zero=%b wb=%2d", ins, rs1, rs2, rd, rd1, rd2, aluZ, zero, wb);
               
                //---------------------------------Prepare for the next ins
                if (ins[6:0] == 7'h63 && zero == 1) //beq if (a-b)=0 then branch
				begin
				        // $display("PCin before: PCin=%h", PCin);
                        PCin = PCin + (branch << 2);
						// $display("PCin after: PCin=%h", PCin);
				end
                else 
				if (ins[6:0] == 7'h6F)  //j jTarget
				begin
				        // $display("20'b11111111111111111011 = ", $signed(20'b11111111111111111011));
				        // $display("$ins[31:12]=%b", ins[31:12]);
				        // $display("$signed($ins[31:12])=%d", $signed(ins[31:12]));
				        // $display("$signed(jTarget)=%d", $signed(jTarget));
				        // $display("PCin=%h", PCin);
                        PCin = PCin+$signed(jTarget << 2) ;
						// $display("PCin=%h", PCin);
				end
                else
                        PCin = PCp4;
               
        end
		
		
		// read mem for testing
		 PCin = 16'h20; // the sum address
		 clk = 1; #1;
		
		 $display("sum=%h", ins);
		
		 clk = 0; #1;
		
        $finish;
end
endmodule