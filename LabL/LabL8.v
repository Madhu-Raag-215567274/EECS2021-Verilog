module yMux1(z, a, b, c);
output z;
input a, b, c;
wire notC, upper, lower;
not my_not(notC, c);
and upperAnd(upper, a, notC);
and lowerAnd(lower, c, b);
or my_or(z, upper, lower);
endmodule 

module yMux(z, a, b, c);
parameter SIZE = 2;
output [SIZE-1:0] z;
input [SIZE-1:0] a, b;
input c;
yMux1 mine[SIZE-1:0](z, a, b, c);
endmodule 

module yAdder1(z, cout, a, b, cin);
output z, cout;
input a, b, cin;
xor left_xor(tmp, a, b);
xor right_xor(z, cin, tmp);
and left_and(outL, a, b);
and right_and(outR, tmp, cin);
or my_or(cout, outR, outL);
endmodule 

module yAdder(z, cout, a, b, cin);
output [31:0] z;
output cout;
input [31:0] a, b;
input cin;
wire[31:0] in, out;
yAdder1 mine[31:0](z, out, a, b, in);
assign in[0] = cin;
assign in[1] = out[0]; 



module yArith (z, cout, a, b, ctrl) ;
   // add if ctrl=0, subtract if ctrl=1
   output [31:0] z;
   output cout;
   input  [31:0] a, b;
   input  ctrl;
   wire   [31:0] notB, tmp;
   wire   cin;

   // instantiate the components and connect them
   assign cin = ctrl;
   not my_not [31:0] (notB, b);
   yMux #(32) mux(tmp, b, notB, cin);
   yAdder adder(z, cout, a, tmp, cin);

endmodule // yArith


module labL;

   reg  signed [31:0] a, b, expect;
   reg  signed        ctrl;
   wire signed [31:0] z;
   wire signed        cout;

   yArith arith(z, cout, a, b, ctrl);

   initial
     begin
        repeat (6)
          begin
             a = $random;
             b = $random;
             ctrl = $random % 2;

             expect = ctrl ? (a - b) : (a + b);

             #1; // wait for z
             if (expect === z)
               $display("PASS: a=%d \n      b=%d \n   ctrl=%b \n      z=%d \n expect=%d",
                        a, b, ctrl, z, expect);
             else
               $display("FAIL: a=%d \n      b=%d \n   ctrl=%b \n      z=%d \n expect=%d",
                        a, b, ctrl, z, expect);

          end
        $finish;
     end

endmodule // LabL