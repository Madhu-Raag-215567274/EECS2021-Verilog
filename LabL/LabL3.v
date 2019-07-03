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

module LabL;

   reg   [31:0] a, b, expect;
   reg   c;
   wire   [31:0] z;
   integer     i, j, k;
   yMux #(.SIZE(32)) mux(z, a, b, c);

   initial
     begin
        repeat (500)
          begin
             a = $random;
             b = $random;
             c = $random % 2;

             expect = c ? b : a;

             #1; // wait for z

               if (z === expect)
               $display("PASS: a=%b \n      b=%b \n      c=%b z=%b", a, b, c, z);
             else
               $display("FAIL: a=%b \n      b=%b \n      c=%b z=%b", a, b, c, z); 

             //if (z !== expect)
               //$display("FAIL: a=%b \n      b=%b \n      c=%b \n      z=%b \n      expect=%b", a, b, c, z, expect);
          end
        $finish;
     end

endmodule  // LabL