`include "mainfsm.v"

module decode (
	clk,
	reset,
	Op,
	Funct,
	Rd,
	FlagW,
	PCS,
	NextPC,
	RegW,
	MemW,
	IRWrite,
	AdrSrc,
	ResultSrc,
	ALUSrcA,
	ALUSrcB,
	ImmSrc,
	RegSrc,
	ALUControl
);

	input wire clk;
	input wire reset;
	input wire [1:0] Op;
	input wire [5:0] Funct;
	input wire [3:0] Rd;
	output reg [1:0] FlagW;
	output wire PCS;
	output wire NextPC;
	output wire RegW;
	output wire MemW;
	output wire IRWrite;
	output wire AdrSrc;
	output wire [1:0] ResultSrc;
	output wire [1:0] ALUSrcA;
	output wire [1:0] ALUSrcB;
	output wire [1:0] ImmSrc;
	output wire [1:0] RegSrc;
	output reg [1:0] ALUControl;
	wire Branch;
	wire ALUOp;


	// Main FSM
	mainfsm fsm(
		.clk(clk),
		.reset(reset),
		.Op(Op),
		.Funct(Funct),
		.IRWrite(IRWrite),
		.AdrSrc(AdrSrc),
		.ALUSrcA(ALUSrcA),
		.ALUSrcB(ALUSrcB),
		.ResultSrc(ResultSrc),
		.NextPC(NextPC),
		.RegW(RegW),
		.MemW(MemW),
		.Branch(Branch),
		.ALUOp(ALUOp)
	);

	// ADD CODE BELOW
	// Add code for the ALU Decoder and PC Logic.
	// Remember, you may reuse code from previous labs.
	// ALU Decoder

	// PC Logic
  assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
  
  //ALU decoder
  always @(*)
      if (ALUOp) begin
          case (Funct[4:1])
            4'b0100: ALUControl = 2'b00;
            4'b0010: ALUControl = 2'b01;
            4'b0000: ALUControl = 2'b10;
            4'b1100: ALUControl = 2'b11;
            4'b0001: ALUControl = 2'b01;
            default: ALUControl = 2'bxx;
          endcase
        FlagW[1] = Funct[0];
        FlagW[0] = Funct[0] & ((ALUControl == 3'b000) | (ALUControl == 3'b001));
      end
      else begin
        ALUControl = 3'b000;
        FlagW = 2'b00;
      end
  
 
	assign ImmSrc = Op;
	assign RegSrc[1] = (Op == 2'b01);
	assign RegSrc[0] = (Op == 2'b10);
  
endmodule