module ALU(a, b, Result, ALUFlags, ALUControl);
  input [31:0] a;
  input [31:0] b;
  input [1:0] ALUControl;
  output reg [31:0] Result;
  output wire [3:0] ALUFlags;
  
  wire neg, zero, carry, overflow;
  wire [32:0] sum;
  
  assign sum = a + (ALUControl[0]? ~b: b) + ALUControl[0]; // 2's complement
  
  always @(*)
    casex (ALUControl[1:0]) //case, casex, casez
      2'b0?: Result = sum;
      2'b10: Result = a&b;  //and
      2'b11: Result = a|b;  //or
    endcase
  
  //flags????
  assign neg = Result[31];
  assign zero = (Result == 32'b0);
  assign carry = (ALUControl[1] == 1'b0) & sum[32];
  assign overflow = (ALUControl[1] == 1'b0) & (sum[31] ^ a[31]) & ~(ALUControl[0] ^ a[31] ^ b[31])
  
  assign ALUFlags = {neg, zero, carry, overflow};
    
endmodule  