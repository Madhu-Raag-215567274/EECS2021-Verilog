module labM ;
   reg   [31:0] wd;
   reg   [4:0]  rn1, rn2, wn;
   reg          clk, w, flag;
   wire [31:0]  rd1, rd2;
   integer      i;

   rf myRF(rd1, rd2, rn1, rn2, wn, wd, clk, w);

   initial
     begin
        flag = $value$plusargs("w=%b", w);

        for (i = 0; i < 32; i = i + 1)
          begin
             clk = 0;
             wd = i * i;
             wn = i;
             clk = 1;
             #1;
          end

        repeat(10)
          begin
             rn1 = $random % 32;
             rn2 = $random % 32;

             #2;
             $display("rn1=%d, rd1=%d, rn2=%d, rd2=%d",rn1,rd1,rn2,rd2);
          end

        $finish;
     end

endmodule // labM