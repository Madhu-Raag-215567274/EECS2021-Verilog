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



module yMux4to1(z, a0,a1,a2,a3, c);
parameter SIZE = 2;
output [SIZE-1:0] z;
input [SIZE-1:0] a0, a1, a2, a3;
input [1:0] c;
wire [SIZE-1:0] zLo, zHi;
yMux #(SIZE) lo(zLo, a0, a1, c[0]);
yMux #(SIZE) hi(zHi, a2, a3, c[0]);
yMux #(SIZE) final(z, zLo, zHi, c[1]);
endmodule




module LabL;

   reg   [31:0] a0, a1, a2, a3, expect;
   reg   [1:0] c;
   wire   [31:0] z;
   yMux4to1 #(.SIZE(32)) mux(z, a0, a1, a2, a3, c);

   initial
     begin
        repeat (500)
          begin
             a0 = $random;
             a1 = $random;
             a2 = $random;
             a3 = $random;
             c = $random % 4;

             if (c === 0)
               expect = a0;
             else if (c === 1)
               expect = a1;
             else if (c === 2)
               expect = a2;
             else
               expect = a3;

             #1; // wait for z

             // display only if a test fails
             if (z !== expect)
               $display("FAIL: a0=%b \n      a1=%b \n      a2=%b \n      a3=%b \n      c=%b \n      z=%b \n      expect=%b",
                        a0, a1, a2, a3, c, z, expect);
          end
        $finish;
     end

endmodule // LabL
