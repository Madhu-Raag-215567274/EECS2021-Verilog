
module ff(q, d, clk, enable);
/****************************
An Edge-Triggerred Flip-flop 
Written by H. Roumani, 2008.
****************************/
output q;
input d, clk, enable;
reg q;

always @ (posedge clk)
  if (enable) q <= d; 

endmodule



module register(q, d, clk, enable);
/****************************
An Edge-Triggerred Register.
Written by H. Roumani, 2008.
****************************/

parameter SIZE = 2;
output [SIZE-1:0] q;
input [SIZE-1:0] d;
input clk, enable;

ff myFF[SIZE-1:0](q, d, clk, enable);

endmodule

module labM ;
   reg   [31:0] d, e, prv;
   reg          clk, enable, flag;
   wire [31:0]  z;

   register #(32) mine(z, d, clk, enable);

   initial
     begin
        flag = $value$plusargs("enable=%b", enable);
        clk = 0;

        $monitor("%5d: clk=%b,d=%d,z=%d,expect=%d", $time, clk, d, z, e);

        repeat (20)
          begin
             #2 prv = d;
             d = $random;
          end

        $finish;
     end

   always
     begin
        #5 clk = ~clk;
     end

   always @(posedge clk)
     e = clk ? d : prv;

endmodule // labM