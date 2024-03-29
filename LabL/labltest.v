
module yAdder1 (z, cout, a, b, cin) ;

   output z, cout;
   input  a, b, cin;

   xor left_xor(tmp, a, b);
   xor right_xor(z, cin, tmp);
   and left_and(outL, a, b);
   and right_and(outR, tmp, cin);
   or my_or(cout, outR, outL);

endmodule // yAdder1

module yAdder (z, cout, a, b, cin) ;

   output [3:0] z;
   output        cout;
   input  [3:0] a, b;
   input         cin;
   wire   [3:0] in, out;

   yAdder1 mine [3:0] (z, out, a, b, in);

   assign in[0] = cin;

   genvar        i;
   generate
      for (i = 1; i < 4; i = i + 1) begin : asg
         assign in[i] = out[i-1];
      end
   endgenerate

   assign cout = out[3];

endmodule // yAdder

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
   
   output [3:0] z;
   output cout;
   input  [3:0] a, b;
   input  ctrl;
   wire   [3:0] notB, tmp;
   wire   cin;

   assign cin = ctrl;
   not my_not [3:0] (notB, b);
   yMux #(4) mux(tmp, b, notB, cin);
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


module ALU4 (z,a, b, op) ;

   input [3:0] a, b;
   input [2:0]  op;
   output [3:0] z;
   wire          cout;
   wire [3:0]   alu_and, alu_or, alu_arith, slt, tmp;
    xor (condition, a[3:0], b[3:0]); /// nxor is negated in the test bench
 
   and m_and [3:0] (alu_and, a, b);
   or m_or [3:0] (alu_or, a, b);
   yArith m_arith (alu_arith, cout, a, b, op[2]);
   yMux4to1 #(.SIZE(4)) mux(z, alu_and, alu_or, alu_arith, slt, op[1:0]);

endmodule 

module t_Alu ;

   reg   [3:0] a, b, expect;
   reg   [2:0] op;
   reg [2:0] ctrl;
   wire [3:0] z;
   reg         ok = 0, flag;
   reg   [2:0] operator;

   ALU4 alu(z, a, b, op);

   initial
     begin
        repeat (10)
          begin
             a = $random;
             b = $random;
             ctrl = 3'b000; // Change this value accordingly *For testing*
             
             if (ctrl === 3'b000)
                expect = a & b;
              
           
             else if (ctrl === 3'b001) 
                expect = a | b;
              
             else if (ctrl === 3'b010)
                expect = a + b;
                
             else if (ctrl === 3'b110) 
                expect = ~(a+b);            
           

             #5;

                   
               $display(" a=%b b=%b z=%b",
                        a, b, expect);
            
          end
        $finish;
     end

endmodule 
