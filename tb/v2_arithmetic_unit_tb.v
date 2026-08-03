module v2_arithmetic_unit_tb();

parameter DATA_WIDTH = 8;
reg  [DATA_WIDTH-1:0] a;
reg  [DATA_WIDTH-1:0] b;
reg  alu_op;

wire [DATA_WIDTH-1:0] result;
wire carry , overflow;

localparam ADD = 1'b0 , SUB = 1'b1;

v2_arithmetic_unit v2_test(
    a,
    b,
    alu_op,
    result,
    carry,
    overflow
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

task check(
    input [DATA_WIDTH-1:0] A,
    input [DATA_WIDTH-1:0] B,
    input ALU,
    input [DATA_WIDTH-1:0] expected_result,
    input expected_carry,
    input expected_overflow
);
begin
    a = A;
    b = B;
    alu_op = ALU;
    #1; // delay
    if(result == expected_result && overflow == expected_overflow
        && carry == expected_carry)
        begin
            $display("PASS Result : %d " ,result);
        end
    else
        begin
            if(result != expected_result)
                begin
                error_count = error_count + 1;
                $display("FAILED result | expected : %d actual_REsult : %d" , expected_result , result);
                end
            if(overflow != expected_overflow)
                begin
                error_count = error_count + 1;
                $display("FAILED overflow | expected : %b actual_overflow : %b" , expected_overflow , overflow);
                end    
            if(carry != expected_carry)
                begin
                error_count = error_count + 1;
                $display("FAILED CARRY | expected : %b actual_carry : %b" , expected_carry , carry);
                end     
        end    
end
endtask

initial begin
    $dumpfile("v2_test.vcd");
    $dumpvars(0, v2_arithmetic_unit_tb);
    $monitor("T = %0t | a = %d | b = %d | ALU = %b | result = %d carry = %b Overflow = %b", 
             $time, a , b , alu_op , result , carry , overflow );
end

initial
begin
  $display("----------------Simulation start----------------");
 a =  0 ; b  = 0  ; alu_op = 0;
 #10; check(23 , 40 , ADD , 63 , 0 , 0 );
 #10; check(1 , 127 , ADD , 128 , 0 , 1 );
 #10; check(100 , 31 , SUB , 69 , 0 , 0 );
 #10; check(90,110,ADD,8'hC8,0,1);
 // Positive overflow
 #10;  check(8'd90 , 8'd110 , ADD , 8'hC8 , 0 , 1);
// Negative overflow
#10; check(8'h80 , 8'hFF , ADD , 8'h7F , 1 , 1);

  $display("----------------------------------------------------------------------");
    $display("Simulation Finished");
    if(error_count==0)
        $display("ALL TESTS PASSED");
    else
        $display("FAILED with %0d errors",error_count);

    $display("-------------------------------------------------------------------");

    $finish();
end
endmodule