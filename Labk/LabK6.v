module labK;

wire z,x,y,cnot,and1; 
reg a,b,c;
not c_not(cnot, c);
and a_1 (x,a,and1);
assign and1=cnot;

and second(y,b,c);
or (z,x,y);


initial

begin
a = 1; b = 0; c = 0;
#1;
$display("a=%b b=%b c=%b z=%b ", a, b,c,z);	

$finish;
end
endmodule