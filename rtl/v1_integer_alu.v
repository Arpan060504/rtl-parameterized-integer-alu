module v1_integer_alu ( a , b , alu_op 
, result,zero , carry , overflow , negative);
 parameter DATA_WIDTH = 8;
 input  [DATA_WIDTH-1:0] a;
input  [DATA_WIDTH-1:0] b;
input  [2:0] alu_op;

output reg [DATA_WIDTH-1:0] result;
output reg  zero , carry , overflow , negative;

reg  [DATA_WIDTH: 0] internal_result;

localparam
    ADD = 3'b000,
    SUB = 3'b001,
    AND = 3'b010,
    OR  = 3'b011,
    XOR = 3'b100,
    SLT = 3'b101;

always @(*)
begin
zero =  0;
carry =  0;
overflow =  0;
result = 0;
internal_result  = 0;
negative  =  0;
    case (alu_op)
        AND : result = a & b;
        OR : result = a | b;
        XOR : result = a ^ b;
        ADD :
        begin
          internal_result  = a +  b;
          carry =  internal_result[DATA_WIDTH] ;
          result  = internal_result[DATA_WIDTH-1:0];
            if(a[DATA_WIDTH-1]==0 && b[DATA_WIDTH-1]==0 && result[DATA_WIDTH-1] ==1)
                    overflow  = 1;
            else if(a[DATA_WIDTH-1]==1 && b[DATA_WIDTH-1]==1 && result[DATA_WIDTH-1] ==0)   
                overflow  = 1;     
        end
        SUB:  
            begin
            result = a - b; 
            end 
        SLT :     
            if(a < b)
                result =  1;
            else
                result =  0;
        default : result = 0;    
    endcase
        zero = (result==0);
        if(result[DATA_WIDTH-1] == 1)
                    negative  = 1;
end

endmodule