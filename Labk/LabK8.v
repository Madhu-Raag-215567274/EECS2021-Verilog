module labK;

   reg a, b, c, flag, expect;
   wire notOutput, lowerInput;
   wire firstAndOut, firstAndIn;
   wire secondAndOut, secondAndIn;
   integer i, j, k;

   not (notOutput, c);
   and (firstAndOut, a, lowerInput);
   and (secondAndOut, c, b);
   or (z, firstAndIn, secondAndIn);
   assign lowerInput = notOutput;
   assign firstAndIn = firstAndOut;
   assign secondAndIn = secondAndOut;

   initial
     begin

        for (i = 0; i < 2; i = i + 1)
          begin
             for (j = 0; j < 2; j = j + 1)
               begin
                  for (k = 0; k < 2; k = k + 1)
                    begin
                       a = i;
                       b = j;
                       c = k;

                       // expect = (a & ~c) | (c & b);
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

endmodule