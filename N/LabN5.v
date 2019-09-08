module labN; 
reg [31:0] entryPoint;
reg clk, INT;
wire [31:0] ins, rd2,PC,rd1,wb;
yChip myChip(ins, rd2, rd1,PC,wb,entryPoint, INT, clk);

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
        
               
        //---------------------------------Execute the ins
	   clk = 0; #1;
        //---------------------------------View results
        #1 $display("%h: x%2d=%2h x%2d=%2h PC =%h", ins,ins[19:15],rd1,ins[24:20],rd2,PC);

        //---------------------------------Prepare for the next ins
        
    end
    $finish;
end
endmodule

    