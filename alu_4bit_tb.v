// alu_4bit_tb.v
// Testbench for 4-bit ALU

`timescale 1ns / 1ps

module alu_4bit_tb;

    // Inputs to the ALU
    reg [3:0] A;
    reg [3:0] B;
    reg [2:0] op_sel;

    // Outputs from the ALU
    wire [3:0] Result;
    wire       CarryOut;
    wire       ZeroFlag;

    // Instantiate the Unit Under Test (UUT)
    alu_4bit uut (
        .A(A),
        .B(B),
        .op_sel(op_sel),
        .Result(Result),
        .CarryOut(CarryOut),
        .ZeroFlag(ZeroFlag)
    );

    // Operation Codes (match those in alu_4bit.v)
    parameter OP_ADD = 3'b000;
    parameter OP_SUB = 3'b001;
    parameter OP_AND = 3'b010;
    parameter OP_OR  = 3'b011;
    parameter OP_XOR = 3'b100;
    parameter OP_NOT = 3'b101;

    // Dump waves for waveform viewer
    initial begin
        $dumpfile("alu_4bit.vcd");
        $dumpvars(0, alu_4bit_tb); // Dump all variables in the testbench and its hierarchy
    end

    // Monitor changes in inputs and outputs
    initial begin
        $monitor("Time: %t | A=%b, B=%b, op_sel=%b | Result=%b, CarryOut=%b, ZeroFlag=%b",
                 $time, A, B, op_sel, Result, CarryOut, ZeroFlag);
    end

    // Stimulus Generation
    initial begin
        // Test ADD
        A = 4'b0101; B = 4'b0010; op_sel = OP_ADD; #10; // 5 + 2 = 7, Carry=0, Zero=0
        A = 4'b1100; B = 4'b0100; op_sel = OP_ADD; #10; // 12 + 4 = 16 (0000 with Carry=1), Carry=1, Zero=1
        A = 4'b1111; B = 4'b0001; op_sel = OP_ADD; #10; // 15 + 1 = 16 (0000 with Carry=1), Carry=1, Zero=1

        // Test SUB
        A = 4'b1000; B = 4'b0011; op_sel = OP_SUB; #10; // 8 - 3 = 5, Borrow=0, Zero=0
        A = 4'b0101; B = 4'b1000; op_sel = OP_SUB; #10; // 5 - 8 = -3 (1101), Borrow=1, Zero=0
        A = 4'b0110; B = 4'b0110; op_sel = OP_SUB; #10; // 6 - 6 = 0, Borrow=0, Zero=1

        // Test AND
        A = 4'b1100; B = 4'b1010; op_sel = OP_AND; #10; // 12 & 10 = 8 (1000), Carry=0, Zero=0
        A = 4'b0101; B = 4'b1010; op_sel = OP_AND; #10; // 5 & 10 = 0 (0000), Carry=0, Zero=1

        // Test OR
        A = 4'b1100; B = 4'b1010; op_sel = OP_OR;  #10; // 12 | 10 = 14 (1110), Carry=0, Zero=0
        A = 4'b0000; B = 4'b0000; op_sel = OP_OR;  #10; // 0 | 0 = 0 (0000), Carry=0, Zero=1

        // Test XOR
        A = 4'b1100; B = 4'b1010; op_sel = OP_XOR; #10; // 12 ^ 10 = 6 (0110), Carry=0, Zero=0
        A = 4'b0110; B = 4'b0110; op_sel = OP_XOR; #10; // 6 ^ 6 = 0 (0000), Carry=0, Zero=1

        // Test NOT
        A = 4'b1010; B = 4'bxxxx; op_sel = OP_NOT; #10; // ~1010 = 0101, Carry=0, Zero=0 (B ignored)
        A = 4'b1111; B = 4'bxxxx; op_sel = OP_NOT; #10; // ~1111 = 0000, Carry=0, Zero=1 (B ignored)

        // Add some more diverse tests if needed
        A = 4'b0011; B = 4'b0100; op_sel = OP_ADD; #10; // 3 + 4 = 7
        A = 4'b0100; B = 4'b0011; op_sel = OP_SUB; #10; // 4 - 3 = 1
        A = 4'b1111; B = 4'b1111; op_sel = OP_AND; #10; // 15 & 15 = 15
        A = 4'b0000; B = 4'b1111; op_sel = OP_OR;  #10; // 0 | 15 = 15
        A = 4'b0101; B = 4'b1010; op_sel = OP_XOR; #10; // 5 ^ 10 = 15

        // End simulation
        $finish;
    end

endmodule