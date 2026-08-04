module v2_logic_unit(
    a,
    b,
    logic_op,
    result
);

parameter DATA_WIDTH = 8;

input [DATA_WIDTH-1:0] a;
input [DATA_WIDTH-1:0] b;
input [1:0] logic_op;

output reg [DATA_WIDTH-1:0] result;

localparam
    AND = 2'b00,
    OR  = 2'b01,
    XOR = 2'b10;

always @(*) begin
    result = 0;

    case (logic_op)
        AND : result = a & b;
        OR  : result = a | b;
        XOR : result = a ^ b;
        default: result = 0;
    endcase
end

endmodule