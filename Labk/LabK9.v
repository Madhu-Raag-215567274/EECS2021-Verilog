module labK;
integer i,j,k;
reg a,b,ci;
reg[1:0] expect;
wire l1,l2,z,tem,co; 

xor (l1,a,b);
and (l2,a,b);
xor (z,ci,l1);
and (tem,l1,ci);
or (co,tem,l2);

initial 
begin 
  for(i=0;i<2;i=i+1)  
      for(j=0;j<2;j=j+1)	   
		       for(k=0;k<2;k=k+1)
			   begin
			   
				 a= i;
				 b= j;
				 ci=k;
				  expect = a + b + ci;
				  #1;////wait
				 if( expect[0] === z && expect[1] === co)
				 
				 $display("PASS: a=%b b=%b cin=%b z=%b cout=%b",
                            a, b, ci, z, co);
				 else 
				 $display("Fail: a=%b b=%b cin=%b z=%b cout=%b",
                            a, b, ci, z, co);
				 
				 end
	$finish;
	  
	 
end 
endmodule