module v1_integer_alu_tb();
parameter DATA_WIDTH= 8;
reg [DATA_WIDTH-1:0] a;
reg [DATA_WIDTH-1:0] b;
reg [2:0] alu_op;

wire [DATA_WIDTH-1:0] result;
wire  zero , carry , overflow , negative;

integer error_count;

localparam
ADD = 3'b000,
SUB = 3'b001,
AND = 3'b010,
OR = 3'b011,
XOR = 3'b100,
SLT = 3'b101;

v1_integer_alu v1_test(

.a(a),
.b(b),
.alu_op(alu_op),

.result(result),
.zero(zero),
.carry(carry),
.overflow(overflow),
.negative(negative)

);

initial // Watchdog timer
    begin
    #500
    $finish();
    end

initial
    begin
    error_count = 0;
    end

task check(input [DATA_WIDTH-1:0] A , input [DATA_WIDTH-1:0] B , input [2:0] ALU 
, input [DATA_WIDTH-1:0] expected_result 
, input expected_Zero, input expected_carry, input expected_overflow, input expected_negative );
begin
     a = A;
     b = B;
     alu_op = ALU;
     #1;
     if( result == expected_result)
        begin
            $display("PASSED : result = %d , expected_result = %d | A = %d , B = %d , ALU = %b "
            , result , expected_result , a , b, alu_op);
        end
    else
        begin
          error_count = error_count + 1;
            $display(" FAILED RESULT : result = %d , expected result = %d for A = %d , B = %d , ALU = %b "
            , result , expected_result , a , b, alu_op);   
        end
    if(zero == expected_Zero 
                    && carry == expected_carry 
                    && overflow == expected_overflow 
                        && negative == expected_negative)
        begin
                $display(" PASSED for all other output parammeters ");   
        end                        
    else                     
        begin    
            if(zero != expected_Zero) 
                begin
                error_count = error_count + 1;
                    $display("FAILED for zero , expected = %b , observation = %b" , expected_Zero , zero);
                end
            if(carry != expected_carry) 
                begin
                error_count = error_count + 1;
                    $display("FAILED for carry , expected = %b , observation = %b" , expected_carry , carry);
                end
            if(overflow != expected_overflow) 
                begin
                error_count = error_count + 1;
                    $display("FAILED for overflow , expected = %b , observation = %b" , expected_overflow , overflow);
                end
            if(negative != expected_negative) 
                begin
                error_count = error_count + 1;
                    $display("FAILED for negative , expected = %b , observation = %b" , expected_negative , negative);         
                end
        end
end        
endtask

initial
begin
 
    $display("Simulation START");
//            A , B , ALU , RESULT , zero , carry , overflow , negative
    #10; check(10 , 10 , ADD , 20 ,0 , 0 , 0 , 0);
    #10; check(8'd127,8'd1,ADD,8'h80,0,0,1,1);
    #10; check(8'hFF,8'h01,ADD,8'h00,1,1,0,0);

    #10; check(50 , 10 , SUB , 40 ,0 , 0 , 0 , 0);
    #10; check(50 , 100 , SUB , 8'hCE ,0 , 0 , 0 , 1);
    #10; check(50,50,SUB,0,1,0,0,0);
    #10; check(8'h80,8'hFF,SUB,8'h81,0,0,0,1);

    #10; check(20,20,AND,20,0,0,0,0);
    #10; check(50 , 10 , AND , 2 ,0 , 0 , 0 , 0);

    #10; check(1 , 1 , OR , 1 ,0 , 0 , 0 , 0);

    #10; check(1 , 1 , XOR , 0 ,1 , 0 , 0 , 0);
    #10; check(1 , 0 , XOR , 1 ,0 , 0 , 0 , 0);

    #10; check(67 , 102 , SLT , 1 ,0,0,0,0);
    #10; check(67 , 39 , SLT , 0 , 1 , 0 , 0 , 0 );
    #10; check(7 , 7 , SLT , 0 , 1 , 0 , 0 , 0 );

    #10; check(76 , 27 , 3'b111 , 0 , 1 , 0 , 0 , 0 );
    
    $display("----------------------------------------------------------------------");
    $display("Simulation Finished");
    if(error_count==0)
        $display("ALL TESTS PASSED");
    else
        $display("FAILED with %0d errors",error_count);

    $display("-------------------------------------------------------------------");

    $finish();
end

initial begin
    $dumpfile("v1_test.vcd");
    $dumpvars(0, v1_integer_alu_tb);
    $monitor("T = %0t | a = %d | b = %d | ALU = %b | result = %d zero = %b cry = %b Oflow = %b neg = %b", 
             $time, a , b , alu_op 
, result ,zero , carry , overflow , negative);
end
endmodule