module LabM;
reg [31:0] memIn, address;
wire [31:0] memOut;
reg clk, read, write;

mem data(memOut, address, memIn, clk, read, write);










/*
initial
	begin
		write = 1; read = 0; address = 16; clk = 0;
		memIn = 32'h12345678;
		#1 clk = 1; 
		#1;
		write = 1; read = 0; address = 24; clk = 0;
		memIn = 32'h89abcdef;
		#1 clk = 1;
		#1;
		write = 0; read = 1; address = 16;
	repeat (3)
		begin
		#1 $display("Address %d contains %h", address, memOut);
		address = address + 4;

	end
	end
	
	
endmodule
*/



initial
begin
	
		write = 1; read = 0; address = 16;
		clk = 0;
		memIn = 32'h12345678;
		#4 read = 1; 
		#1 $display("Address %d contains %h clk %d", address, memOut, clk); 
		address = address + 4; 
		#4 read = 0;
		memIn = 32'h89abcdef;
		#4 read = 1;
		#1 $display("Address %d contains %h clk %d", address, memOut, clk); 
		#4;
		write = 0; read = 1; address =16; 
		repeat (10) 
		begin 
			
			if(address%4!=0) 
			#4 $display("Unaligned Address %d", address); 
			else
			#4 $display("Address %d contains %h clk %d", address, memOut, clk); 
			address = address + 4; 
		end 
		$finish;

end
always
begin
		#4 clk = ~clk;
end
endmodule
