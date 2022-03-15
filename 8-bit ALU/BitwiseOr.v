module BitwiseOr(A, B, result,ZeroFlag);  
input  [7:0] A;  
input  [7:0] B;  
output [7:0] result;  
output ZeroFlag;  
reg [7:0] result;
reg ZeroFlag; 
 
always @(A or B)
begin
 result = A | B;

if(result == 8'b00000000)
 ZeroFlag =1;
   else 
  ZeroFlag =0;

end
  endmodule 