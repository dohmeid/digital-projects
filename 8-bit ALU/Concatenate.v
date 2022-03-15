module Concatenate(A,B,result);
input  [7:0] A;  
input  [7:0] B;  
output [7:0] result; 
reg [7:0] result;

always @(A or B)

 {result} ={ A[3:0] , B[3:0]};
 
 endmodule 