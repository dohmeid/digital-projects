module mux2x1( D0, D1, S, Y);
input D0, D1;
input [2:0] S;
output reg Y;

always @(D0 or D1 or S)
begin

if(S == 3'b000) 
Y= D0;
else if(S == 3'b001)
Y= D1;
else 
Y= 0;

end
endmodule 