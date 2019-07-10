module labM;
reg clk, read, write;
reg [31:0] address, memIn;
wire [31:0] memOut;
mem data(memOut, address, memIn, clk, read, write);
initial
begin
address = 40; write = 0; read = 1;
repeat (11)
begin
			#4 read = 1;
			//R-type
			if (memOut[6:0] == 7'h33)
   				#4 $display("%2h %2h %2h %2h %2h %2h", memOut[31:25], memOut[24:20],memOut[19:15], memOut[14:12], memOut[11:7], memOut[6:0]); 
			//UJtype
   			if (memOut[6:0] == 7'h6F)
				#4 $display("%2h %2h %2h", memOut[31:12], memOut[11:7], memOut[6:0]); 
				//Itype- lw n ADDI
			if (memOut[6:0] == 7'h3 ||  memOut[6:0] == 'h13)
   				#4 $display("%2h %2h %2h %2h %2h     ", memOut[31:20], memOut[19:15], memOut[14:12], memOut[11:7], memOut[6:0]); 
			//S-type
			if (memOut[6:0] == 7'h23)
   				#4 $display("%2h %2h %2h %2h %2h %2h", memOut[31:25], memOut[24:20],memOut[19:15], memOut[14:12], memOut[11:7], memOut[6:0]); 
				//SB-type
			if (memOut[6:0] == 7'h63)
   				#4 $display("%2h %2h %2h %2h %2h %2h",memOut[31:25], memOut[24:20], memOut[19:15], memOut[14:12], memOut[11:7], memOut[6:0]);	
			address = address + 4; 

   		end
		$finish;  
end
always
begin
		#4 clk = ~clk;
end
endmodule 
