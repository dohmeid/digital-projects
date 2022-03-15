module mux8x1(add,subtract,reminder,bitand,bitor,concat,equal,less,C,result);
input [7:0] add,subtract,reminder,bitand,bitor,concat;
input equal,less;
input [2:0]C;
output [7:0] result;
reg [7:0] result;

always @(add or subtract or reminder or bitand or bitor or concat or equal or less or C)

        case(C)
        3'b000: 
           result = add; 
        3'b001: 
            result = subtract;  
        3'b010: 
            result = reminder;  
        3'b011: 
          result =bitand; 
        3'b100: 
           result = bitor; 
         3'b101: 
          result = concat; 
         3'b110:
           result = equal; 
         3'b111: 
         result = less; 
        
endcase
endmodule
