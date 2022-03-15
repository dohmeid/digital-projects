module LessThan(A, B, Cout);  
input  [7:0] A;  
input  [7:0] B;  
output Cout;
reg Cout;

always @( A or B)
begin 
if(A < B)
Cout = 1;
else 
Cout =0;

end
endmodule  