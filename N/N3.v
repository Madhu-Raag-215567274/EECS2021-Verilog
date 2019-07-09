module labN; 
wire [31:0] PC,branchImm,jImm; 
reg RegDst, clk; 
reg [2:0] op; 
wire [31:0] wd, rd1, rd2, imm, ins, PCp4, z;  
wire [31:0] jTarget, branch,memOut,wb;
wire zero;
wire [31:0] PCin;
reg [31:0] entryPoint;
wire isStype, isRtype, isItype, isLw, isjump, isbranch,  ALUSrc, Mem2Reg, MemWrite, MemRead, RegWrite;
reg INT;
//yIF myIF(ins, PCp4, PCin, clk);

yIF myIF(ins, PC, PCp4, PCin, clk);
yID myID(rd1, rd2, imm, jImm, branchImm, ins, wd, RegWrite, clk);
yEX myEx(z, zero, rd1, rd2, imm, op, ALUSrc);
yDM myDM(memOut, z, rd2, clk, MemRead, MemWrite);
yWB myWB(wb, z, memOut, Mem2Reg);
yPC myPC(PCin, PC, PCp4,INT,entryPoint,branchImm,jImm,zero,isbranch,isjump);
yC1 myC1(isStype, isRtype, isItype, isLw, isjump, isbranch, ins[6:0]);
yC2 myC2(RegWrite, ALUSrc, MemRead, MemWrite, Mem2Reg,
 isStype, isRtype, isItype, isLw, isjump, isbranch);
assign wd = wb;
initial 
begin
    //------------------------------------Entry point
     entryPoint = 32'h28; INT=1; #1;
    //------------------------------------Run program
  repeat (43)
    begin
    //---------------------------------Fetch an ins
        clk = 1; #1; INT=0;
        //---------------------------------Set control signals 
        op = 3'b010;         
        // Add statements to adjust the above defaults
        //R type n lw is changing register value so regwrite =1
        
		//#1;
        if(ins[6:0] == 7'h33 && ins[14:12] == 3'b110) //R-typeOR type
            begin
            op=3'b001;
				
            end
        else if(ins[6:0] == 7'h33 && ins[14:12] == 3'b000)  // add RType
        	begin
            op=3'b010;
            end

       
        //---------------------------------Execute the ins
	   clk = 0; #1;
        //---------------------------------View results
        #1 $display("%h: rd1=%2d rd2=%2d z=%3d zero=%b wb=%2d %h",
        ins, rd1, rd2, z, zero, wb, PCin);

        //---------------------------------Prepare for the next ins
        
    end
    $finish;
end
endmodule

    