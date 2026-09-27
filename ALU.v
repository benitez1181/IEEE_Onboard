/* I had to change the testbench to work on Icarus Verilog, but kepts the same 
    test cases. Not sure if it was possible to run SV testbench on Icarus Verilog
*/
module ALU(
    input wire signed [31: 0] A, B,
    input wire [2:0] ALUControl,
    output reg signed [31:0] Result,
    output reg Zero, Negative, Overflow, Carry
);

reg signed [32:0] temp;
localparam ADD = 3'b000, SUB = 3'b001, AND = 3'b010, OR = 3'b011, SLT = 3'b101;

always @(*) begin
    Zero = 0;
    Negative = 0;
    Overflow = 0;
    Carry = 0;

    case (ALUControl)
        ADD:begin
            temp = {1'b0, A} + {1'b0, B};
            Result = temp[31:0];
        end
        SUB: Result = A - B;
        AND: Result = A & B;
        OR: Result = A ^ B;
        SLT: Result = A < B;
        default: Result = 0;
    endcase

    if(Result == 0)
        Zero = 1;
    else if(Result < 0) begin
        case (ALUControl)
            ADD: begin
                if(A > 0 && B > 0)
                    Overflow = 1;
            end
            SUB: begin
                if(A > 0 && B < 0)
                    Overflow = 1;
            end
        endcase
        Negative = 1;
    end
    else begin
        case (ALUControl)
            ADD: begin
                if(A < 0 && B < 0)
                    Overflow = 1;
            end
            SUB: begin
                if(A < 0 && B > 0)
                    Overflow = 1;
            end
        endcase
    end

    Carry = temp[32];
    
end
endmodule