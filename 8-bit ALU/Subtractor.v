module Subtractor(A, B, result, Cout,OverFlow,ZeroFlag);  
input  [7:0] A;  
input  [7:0] B;  
output [7:0] result; 
output Cout,OverFlow,ZeroFlag;  
reg [7:0] result;
reg Cout,OverFlow,ZeroFlag;  

always @(A or B)
begin
 {Cout,result}= A-B;

  if(Cout == 1)
   OverFlow=1;
   else 
   OverFlow=0;

  
  if(result == 8'b00000000)
   ZeroFlag =1;
   else 
    ZeroFlag =0;

  end
endmodule 
 