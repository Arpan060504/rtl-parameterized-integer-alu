module v2_logic_unit_tb;

parameter DATA_WIDTH = 8;

reg [DATA_WIDTH-1:0] a;
reg [DATA_WIDTH-1:0] b;
reg [1:0] logic_op;

wire [DATA_WIDTH-1:0] result;

localparam
    AND = 2'b00,
    OR  = 2'b01,
    XOR = 2'b10;

v2_logic_unit v2_test(
    a,
    b,
    logic_op,
    result
);


initial // Watchdog timer
    begin
    #500;
    $finish();
    end

integer error_count ;
initial
    begin
    error_count = 0;
    end

task check(input [DATA_WIDTH-1:0] A  , input [DATA_WIDTH-1:0] B 
, input [1:0] ALU , input [DATA_WIDTH-1:0] expected_result );
begin
 a = A;
 b = B;
 logic_op  = ALU;
 #1;
 if(result == expected_result)
    $display("PASS | A=%h B=%h OP=%b RESULT=%h", A , B , ALU ,result);
 else
    begin 
    $display("FAILED ALU : %b | expeceted : %b , observed : %b " ,ALU, expected_result  , result);
    error_count = error_count +  1;
    end
end
endtask

initial
begin
$display("--------START Simulation------------------");
 a = 0 ; b  = 0;
 #10; check(20 , 20 ,  AND,20);
 #10; check(50 , 10 , AND,2);

 #10; check( 1, 1  , OR , 1); 
 #10; check( 0, 1  , OR , 1);     
 #10; check( 0, 0  , OR , 0);  
 #10; check( 8'hAA, 8'h55  , OR , 8'hFF);     
 #10; check( 8'hFF, 8'h00 , OR , 8'hFF);  

 #10; check( 1, 1  , XOR , 0);
 #10; check( 1, 0  , XOR , 1);
 #10; check( 8'hFF, 8'hFF  , XOR , 0);

 #10; check(8'h00,8'hFF,AND,8'h00);
 #10; check(8'hFF,8'h00,XOR,8'hFF);
 #10; check(8'hAA,8'hAA,XOR,8'h00);
 #10; check(8'h55,8'hAA,AND,8'h00);

// default case
 #10; check(8'h12,8'h34,2'b11,0);

 $display("--------------------------------");

if(error_count==0)
    $display("ALL TESTS PASSED");
else
    $display("FAILED WITH %0d ERRORS",error_count);

$display("--------------------------------");

#10; $finish();
end

initial
begin
    $dumpfile("v2_test.vcd");
    $dumpvars( 0 , v2_logic_unit_tb);
    $monitor("T = %0t | a = %d | b = %d | ALU = %b | result = %d ", 
             $time, a , b , logic_op , result);
end

endmodule    