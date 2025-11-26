
module array_multiplier_4x4 (
    input  wire [3:0] A,  // 4-bit Multiplier
    input  wire [3:0] B,  // 4-bit Multiplicand
    output wire [7:0] P   // 8-bit Product
);

    wire [3:0] pp0, pp1, pp2, pp3;  // Partial Products
    wire [5:0] s1, s2;              // Sum intermediate stages
    wire [3:0] c1, c2;              // Carry intermediate stages
    wire [6:0] s3;                  // Final sum stage
    wire [5:0] c3;                  // Final carry stage

    // Generate Partial Products
    assign pp0 = A & {4{B[0]}}; // Row 0
    assign pp1 = A & {4{B[1]}}; // Row 1
    assign pp2 = A & {4{B[2]}}; // Row 2
    assign pp3 = A & {4{B[3]}}; // Row 3

    // First Stage Addition
    assign {c1[2:0], s1[3:0]} = {1'b0, pp0[3:0]} + {pp1[2:0], 1'b0};
    assign {c1[3], s1[5:4]}   = {pp1[3], 1'b0}  + {1'b0, pp2[1:0]};

    // Second Stage Addition
    assign {c2[2:0], s2[3:0]} = {1'b0, s1[3:0]} + {pp2[2:0], 2'b00} + {c1[2:0], 1'b0};
    assign {c2[3], s2[5:4]}   = {s1[5:4]} + {pp3[1:0], 1'b0} + {c1[3], 1'b0};

    // Third Stage Addition
    assign {c3[2:0], s3[3:0]} = {1'b0, s2[3:0]} + {pp3[2:0], 2'b00} + {c2[2:0], 1'b0};
    assign {c3[5:3], s3[6:4]} = {s2[5:4]} + {c2[3], pp3[3]} + {c3[2:0], 1'b0};

    // Final Product Output
    assign P = {c3[5:3], s3[6:0]};

endmodule

module tb_array_multiplier_4x4;

    reg [3:0] A, B;
    wire [7:0] P;

    // Instantiate the multiplier
    array_multiplier_4x4 uut (
        .A(A),
        .B(B),
        .P(P)
    );

    initial begin
        $monitor("Time=%0t | A=%b (%d) | B=%b (%d) | P=%b (%d)", 
                  $time, A, A, B, B, P, P);

        #10 A = 4'b0011; B = 4'b0010; // 3 × 2 = 6
        #10 A = 4'b0101; B = 4'b0011; // 5 × 3 = 15
        #10 A = 4'b0110; B = 4'b0100; // 6 × 4 = 24
        #10 A = 4'b1111; B = 4'b0001; // 15 × 1 = 15
        #10 A = 4'b1010; B = 4'b1100; // 10 × 12 = 120
        #10 $finish;
    end

endmodule
