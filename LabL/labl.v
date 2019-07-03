module yAdder (z, cout, a, b, cin) ;

   output [31:0] z;
   output        cout;
   input  [31:0] a, b;
   input         cin;
   wire   [31:0] in, out;

   yAdder1 mine [31:0] (z, out, a, b, in);

   assign in[0] = cin;

   genvar        i;
   generate
      for (i = 1; i < 32; i = i + 1) begin : asg
         assign in[i] = out[i-1];
      end
   endgenerate

   assign cout = out[31];

endmodule // yAdder
module yMux(z, a, b, c);
   parameter SIZE = 2;
   output [SIZE-1:0] z;
   input  [SIZE-1:0] a, b;
   input  c;

   yMux1 mine[SIZE-1:0](z, a, b, c);

endmodule // yMux

module yMux1(z, a, b, c);
   output z;
   input  a, b, c;
   wire   notC, upper, lower;

   not my_not(notC, c);
   and upperAnd(upper, a, notC);
   and lowerAnd(lower, c, b);
   or my_or(z, upper, lower);

endmodule // yMux1


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

module yMux(z, a, b, c);
   parameter SIZE = 2;
   output [SIZE-1:0] z;
   input  [SIZE-1:0] a, b;
   input  c;

   yMux1 mine[SIZE-1:0](z, a, b, c);

endmodule // yMux


module yMux4to1(z, a0, a1, a2, a3, c);
   parameter SIZE = 2;
   output [SIZE-1:0] z;
   input  [SIZE-1:0] a0, a1, a2, a3;
   input  [1:0] c;
   wire   [SIZE-1:0] zLo, zHi;

   yMux #(SIZE) lo(zLo, a0, a1, c[0]);
   yMux #(SIZE) hi(zHi, a2, a3, c[0]);
   yMux #(SIZE) final(z, zLo, zHi, c[1]);

endmodule // yMux4to1
module yAlu (z, ex, a, b, op) ;

   input [3:0] a, b;
   input [2:0]  op;
   output [3:0] z;
   output        ex;
   wire          cout;
   wire [3:0]   alu_and, alu_or, alu_arith, slt, tmp;

   xor (condition, a[3:0], b[3:0]);
   yArith slt_arith (tmp, cout, a, b, 1);
   yMux #(.SIZE(1)) slt_mux(slt[0], tmp[3:0], a[3:0], condition);
   and m_and [3:0] (alu_and, a, b);
   or m_or [3:0] (alu_or, a, b);
   yArith m_arith (alu_arith, cout, a, b, op[2]);
   yMux4to1 #(.SIZE(4)) mux(z, alu_and, alu_or, alu_arith, slt, op[1:0]);

endmodule 

module labL ;

   reg   [3:0] a, b, expect;
   reg   [2:0] op;
   wire        ex;
   wire [3:0] z;
   reg         ok = 0, flag;
   reg   [2:0] operator;

   yAlu alu(z, ex, a, b, op);

   initial
     begin
        repeat (2)
          begin
             a = $random;
             b = $random;
             flag = $value$plusargs("op=%d", op);

             // The oracle: compute "expect" based on "op"
             if (op === 3'b000) begin
                expect = a & b;
                operator = "&";
             end
             else if (op === 3'b001) begin
                expect = a | b;
                operator = "|";
             end
             else if (op === 3'b010) begin
                expect = a + b;
                operator = "+";
             end
             else if (op === 3'b110) begin
                expect = a - b;
                operator = "-";
             end

             #1;

             // Compare the circuit's output with "expect"
             // and set "ok" accordingly
             ok = (expect === z) ? 1 : 0;

             if (ok)
               $display("PASS:  a=%b\n       b=%b\n     a%sb=%b\n",
                        a, b, operator, z);
             else
               $display("FAIL:  a=%b\n       b=%b\n     a%sb=%b\nexpected=%b\n",
                        a, b, operator, z, expect);
          end
        $finish;
     end

endmodule // LabL
