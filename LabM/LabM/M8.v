        
module labM;
reg [31:0] PCin;
reg RegDst, RegWrite, clk, ALUSrc; 
reg [2:0] op;
wire [31:0] wd, rd1, rd2, imm, ins, PCp4, z; 
wire [31:0] jTarget, branch;
wire zero;                              
yIF myIF(ins, PCp4, PCin, clk);
yID myID(rd1, rd2, imm, jTarget, branch, ins, wd, RegWrite, clk); 
yEX myEx(z, zero, rd1, rd2, imm, op, ALUSrc);
assign wd = z;

initial 
begin
    //------------------------------------Entry point
     PCin = 16'h28;
    //------------------------------------Run program
    repeat (11)
    begin
    //---------------------------------Fetch an ins
        clk = 1; #1;
        //---------------------------------Set control signals 
        RegDst = 0; RegWrite = 0; ALUSrc = 1; op = 3'b010;
        // Add statements to adjust the above defaults
        if(ins[6:0] == 'h33) //R-type
            begin
            RegDst = 0; RegWrite = 1; ALUSrc = 0;
            end

        if(ins[6:0] == 'h03 || ins[6:0] == 'h13) // I-type lw:  rd, imm(rs1)
        begin
            RegDst = 0; RegWrite = 1; ALUSrc = 1;
        end

        if(ins[6:0] == 'h63) // SB type beq- do subtraction ,op=110 
        begin
            RegDst = 0; RegWrite = 0; ALUSrc = 0; //alusrc 1
        end
        
        if(ins[6:0] == 'h6F) // UJ type
        begin
            RegDst = 0; RegWrite = 1; ALUSrc = 1;
        end

        if(ins[6:0] == 'h23) // S type // 2 sources no rd.
        begin
            RegDst = 0; RegWrite = 0; ALUSrc = 1;
        end

        //---------------------------------Execute the ins
        clk = 0; #1;
        //---------------------------------View results
        #1 $display("instruction: %h rd1: %h rd2: %h immediate: %h jTarget: %h zero: %h z: %d ", ins, rd1, rd2, imm, jTarget, zero, z);

        //---------------------------------Prepare for the next ins
        PCin = PCp4;
    end
    $finish;
end
endmodule

    