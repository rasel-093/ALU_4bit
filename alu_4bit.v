// alu_4bit.v
// 4-bit Arithmetic Logic Unit

module alu_4bit (
    input  [3:0] A,         // 4-bit Operand A
    input  [3:0] B,         // 4-bit Operand B
    input  [2:0] op_sel,    // 3-bit Operation Select
    output [3:0] Result,    // 4-bit Result
    output       CarryOut,  // Carry/Borrow Flag
    output       ZeroFlag   // Zero Flag (Result is 0)
);

    // Internal signals
    reg  [3:0] result_reg;
    reg        carry_reg;
    reg        zero_reg;

    // Operation Codes
    parameter OP_ADD = 3'b000;
    parameter OP_SUB = 3'b001;
    parameter OP_AND = 3'b010;
    parameter OP_OR  = 3'b011;
    parameter OP_XOR = 3'b100;
    parameter OP_NOT = 3'b101; // NOT A (B is ignored)

    // Main combinational logic for ALU operations
    always @(*) begin
        // Default values
        result_reg = 4'b0000;
        carry_reg = 1'b0;

        case (op_sel)
            OP_ADD: begin // A + B
                {carry_reg, result_reg} = A + B; // Addition and capture carry
            end
            OP_SUB: begin // A - B (using two's complement A + ~B + 1)
                {carry_reg, result_reg} = A + (~B) + 1; // Subtraction and capture borrow (inverted carry)
                carry_reg = ~carry_reg; // Invert carry to get borrow flag (1 if borrow occurred)
            end
            OP_AND: begin // A & B
                result_reg = A & B;
                carry_reg = 1'b0; // Carry not applicable for logic ops
            end
            OP_OR: begin // A | B
                result_reg = A | B;
                carry_reg = 1'b0; // Carry not applicable for logic ops
            end
            OP_XOR: begin // A ^ B
                result_reg = A ^ B;
                carry_reg = 1'b0; // Carry not applicable for logic ops
            end
            OP_NOT: begin // ~A (B is ignored)
                result_reg = ~A;
                carry_reg = 1'b0; // Carry not applicable for logic ops
            end
            default: begin // Handle undefined op_sel
                result_reg = 4'bxxxx; // Undefined result
                carry_reg = 1'bx;    // Undefined carry
            end
        endcase
    end

    // Logic for Zero Flag
    assign ZeroFlag = (result_reg == 4'b0000) ? 1'b1 : 1'b0;

    // Assign internal registers to outputs
    assign Result   = result_reg;
    assign CarryOut = carry_reg;

endmodule