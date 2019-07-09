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
   reg   [31:0] d;
   reg          clk, enable, flag;
   wire [31:0]  z;

   register #(32) mine(z, d, clk, enable);

   initial
     begin
        flag = $value$plusargs("enable=%b", enable);

        d = 15;
        clk = 0;
        #1;
        $display("clk=%b d=%d, z=%d", clk, d, z);

        d = 20;
        clk = 1;
        #1;
        $display("clk=%b d=%d, z=%d", clk, d, z);

        d = 25;
        clk = 0;
        #1;
        $display("clk=%b d=%d, z=%d", clk, d, z);

        d = 30;
        clk = 1;
        #1;
        $display("clk=%b d=%d, z=%d", clk, d, z);

        $finish;
     end
endmodule // labM