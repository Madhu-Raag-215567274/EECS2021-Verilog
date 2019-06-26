
module yMux(z, a, b, c);
parameter SIZE = 2;
output [SIZE-1:0] z;
input [SIZE-1:0] a, b;
input c;
yMux1 mine[SIZE-1:0](z, a, b, c);
endmodule 


module yMux1(z, a, b, c);
output z;
input a, b, c;
wire notC, upper, lower;
not my_not(notC, c);
and upperAnd(upper, a, notC);
and lowerAnd(lower, c, b);
or my_or(z, upper, lower);
endmodule 




module yMux2(z, a, b, c);
output [1:0] z;
input [1:0] a, b;
input c;
yMux1 upper(z[0], a[0], b[0], c);
yMux1 lower(z[1], a[1], b[1], c);
endmodule 




module LabL;

   reg   [1:0] a, b, expect;
   reg   c;
   wire   [1:0] z;
   integer     i, j, k;
   yMux2 mux(z, a, b, c);

   initial
     begin

        for (i = 0; i < 4; i = i + 1)
          begin
             for (j = 0; j < 4; j = j + 1)
               begin
                  for (k = 0; k < 2; k = k + 1)
                    begin
                       a = i;
                       b = j;
                       c = k;

                       expect = c ? b : a;

                       #1; // wait for z
                       if (z === expect)
                         $display("PASS: a=%b b=%b c=%b z=%b", a, b, c, z);
                       else
                         $display("FAIL: a=%b b=%b c=%b z=%b", a, b, c, z);
                    end
               end
          end
        $finish;
     end

endmodule // LabL