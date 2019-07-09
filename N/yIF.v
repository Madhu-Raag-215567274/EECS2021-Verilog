module yIF(ins, PCp4, PCin, clk);
output [31:0] ins, PCp4;
input [31:0] PCin;
input clk;
wire [31:0] z;
// build and connect the circuit

yAlu mine(PCp4, ex, 4, z, 3'b010);
//mem data(ins, z,0 , clk, 'b1, 'b0); 
mem data(ins, z, 0, clk, 1'b1, 1'b0);

register #(32) min(z, PCin, clk, 1'b1);

endmodule