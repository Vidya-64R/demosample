module alu #(parameter WIDTH = 8) (
    input  wire [WIDTH-1:0] A, B,  // ALU inputs
    input  wire [3:0] ALU_OP,      // ALU operation selector
    output reg  [WIDTH-1:0] RESULT,// ALU result
    output reg  ZERO,              // Zero flag
    output reg  CARRY,             // Carry flag
    output reg  OVERFLOW           // Overflow flag
);

    always @(*) begin
        // Default values
        RESULT = 0;
        CARRY = 0;
        OVERFLOW = 0;
        ZERO = 0;

        case (ALU_OP)
            4'b0000: {CARRY, RESULT} = A + B;           // ADD
            4'b0001: {CARRY, RESULT} = A - B;           // SUBTRACT
            4'b0010: RESULT = A & B;                    // AND
            4'b0011: RESULT = A | B;                    // OR
            4'b0100: RESULT = A ^ B;                    // XOR
            4'b0101: RESULT = ~(A | B);                 // NOR
            4'b0110: RESULT = A << 1;                   // Logical Shift Left
            4'b0111: RESULT = A >> 1;                   // Logical Shift Right
            4'b1000: RESULT = (A < B) ? 1 : 0;          // Less Than Comparison
            4'b1001: RESULT = A * B;                    // Multiplication (basic)
            default: RESULT = 0;                        // Default case
        endcase

        // Set Zero flag
        if (RESULT == 0)
            ZERO = 1;

        // Set Overflow flag for addition/subtraction
        if ((ALU_OP == 4'b0000) && ((A[WIDTH-1] == B[WIDTH-1]) && (RESULT[WIDTH-1] != A[WIDTH-1])))
            OVERFLOW = 1;
        if ((ALU_OP == 4'b0001) && ((A[WIDTH-1] != B[WIDTH-1]) && (RESULT[WIDTH-1] != A[WIDTH-1])))
            OVERFLOW = 1;
    end
endmodule

//testbench
module tb_alu;
    reg [7:0] A, B;
    reg [3:0] ALU_OP;
    wire [7:0] RESULT;
    wire ZERO, CARRY, OVERFLOW;

    // Instantiate ALU
    alu uut (
        .A(A), .B(B), .ALU_OP(ALU_OP),
        .RESULT(RESULT), .ZERO(ZERO), .CARRY(CARRY), .OVERFLOW(OVERFLOW)
    );

    initial begin
        $monitor("Time=%0t | A=%h | B=%h | OP=%b | Result=%h | Zero=%b | Carry=%b | Overflow=%b",
                 $time, A, B, ALU_OP, RESULT, ZERO, CARRY, OVERFLOW);

        // Test ADD
        A = 8'h14; B = 8'h22; ALU_OP = 4'b0000; #10;
        
        // Test SUBTRACT
        A = 8'h50; B = 8'h10; ALU_OP = 4'b0001; #10;
        
        // Test AND
        A = 8'hFF; B = 8'h0F; ALU_OP = 4'b0010; #10;
        
        // Test OR
        A = 8'hF0; B = 8'h0F; ALU_OP = 4'b0011; #10;
        
        // Test XOR
        A = 8'hAA; B = 8'h55; ALU_OP = 4'b0100; #10;
        
        // Test LESS THAN
        A = 8'h10; B = 8'h20; ALU_OP = 4'b1000; #10;
        
        // Test MULTIPLICATION
        A = 8'h03; B = 8'h04; ALU_OP = 4'b1001; #10;

        #20;
        $finish;
    end
endmodule
