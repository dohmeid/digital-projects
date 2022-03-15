module ALU(X,Y,C,Z,Cout,OV,ZeroFlag);
input [7:0] X,Y;
input [2:0] C;
output [7:0] Z;
output Cout,OV,ZeroFlag;
wire [7:0] r1,r2,r3,r4,r5,r6;
wire ov1,ov2;
wire c1,c2,c3;
wire zf1,zf2,zf3,zf4,zf5,zf6;
Adder add(X,Y,r1,c1,ov1,zf1);
Subtractor sub(X, Y, r2, c2,ov2,zf2);
Reminder rem(X, Y, r3,zf3);  
BitwiseAnd band(X, Y, r4,zf4);  
BitwiseOr bor(X, Y, r5,zf5); 
Concatenate concat(X,Y,r6);
Equality equal(X, Y, zf6);
LessThan less(X, Y, c3);    

mux8x1 mux1(r1,r2,r3,r4,r5,r6,zf6,c3,C,Z); // to get Z
muxx8x1 mux2(zf1, zf2, zf3, zf4, zf5, 0, zf6, 0, C , ZeroFlag); //to get zeroflag
mux2x1 mux3(ov1,ov2,C,OV);//to get overflow/OV
muxx8x1 mux4(c1, c2, 0, 0, 0, 0, 0, c3, C , Cout); //to get cout

endmodule 