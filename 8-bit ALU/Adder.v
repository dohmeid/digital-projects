module Adder(A, B, sum, Cout,OverFlow,ZeroFlag);  
input  [7:0] A;  
input  [7:0] B;  
output [7:0] sum;  
output Cout,OverFlow,ZeroFlag;  
reg [7:0] sum;
reg Cout,OverFlow,ZeroFlag;  

always @(A or B)
begin
{Cout,sum} = A+B;

  if(Cout ==1)
   OverFlow=1;
   else 
   OverFlow=0;

  
  if(sum== 8'b00000000)
   ZeroFlag =1;
   else 
    ZeroFlag =0;

  end
endmodule 