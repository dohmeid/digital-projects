module Equality(A, B, ZeroFlag);  
input  [7:0] A;  
input  [7:0] B;  
output ZeroFlag;
reg ZeroFlag;

always @( A or B)
begin 
if(A ==B)
ZeroFlag = 1;
else 
ZeroFlag =0;

end
endmodule  