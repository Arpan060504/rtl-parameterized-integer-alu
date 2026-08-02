/* Inputs:
- a
- b
- add_sub_select

Outputs:
- result
- carry
- overflow */

module v2_arithmetic_unit(
    a,
    b,
    alu_op,
    result,
    carry,
    overflow
);
parameter DATA_WIDTH = 8;
input  [DATA_WIDTH-1:0] a;
input  [DATA_WIDTH-1:0] b;
input  alu_op;

output reg [DATA_WIDTH-1:0] result;
output reg carry , overflow;
reg [DATA_WIDTH:0] temp;

localparam ADD = 1'b0 , SUB = 1'b1;

always @(*)
begin
    result = 0;
    carry = 0;
    overflow = 0;
    case(alu_op)
        ADD:
        begin 
            temp = a + b;
            result = temp[DATA_WIDTH-1:0];
            carry = temp[DATA_WIDTH];
            overflow = (~(a[DATA_WIDTH-1] ^ b[DATA_WIDTH-1])) & (a[DATA_WIDTH-1] ^ result[DATA_WIDTH-1]);
        end
        SUB: 
        begin 
            temp = a - b;
            result = temp[DATA_WIDTH-1:0];
            carry = temp[DATA_WIDTH];
            overflow = (a[DATA_WIDTH-1] ^ b[DATA_WIDTH-1]) & (a[DATA_WIDTH-1] ^ result[DATA_WIDTH-1]);
        end
        default:
        begin
            result = 0;
            carry = 0;
            overflow = 0;
        end
    endcase
end
endmodule