`include "regfile.v"
`include "extend.v"
`include "mux2.v"
`include "mux3.v"
`include "ALU.v"

module datapath (
	clk,
	reset,
	Adr,
	WriteData,
	ReadData,
	Instr,
	ALUFlags,
	PCWrite,
	RegWrite,
	IRWrite,
	AdrSrc,
	RegSrc,
	ALUSrcA,
	ALUSrcB,
	ResultSrc,
	ImmSrc,
	ALUControl
);

	input wire clk;
	input wire reset;
	output wire [31:0] Adr;
	output wire [31:0] WriteData;
	input wire [31:0] ReadData;
	output wire [31:0] Instr;
	output wire [3:0] ALUFlags;
	input wire PCWrite;
	input wire RegWrite;
	input wire IRWrite;
	input wire AdrSrc;
	input wire [1:0] RegSrc;
	input wire [1:0] ALUSrcA;
	input wire [1:0] ALUSrcB;
	input wire [1:0] ResultSrc;
	input wire [1:0] ImmSrc;
	input wire [1:0] ALUControl;
	wire [31:0] PCNext;
	wire [31:0] PC;
	wire [31:0] ExtImm;
	wire [31:0] SrcA;
	wire [31:0] SrcB;
	wire [31:0] Result;
	wire [31:0] Data;
	wire [31:0] RD1;
	wire [31:0] RD2;
	wire [31:0] A;
	wire [31:0] ALUResult;
	wire [31:0] ALUOut;
	wire [3:0] RA1;
	wire [3:0] RA2;

	parameter PC4 = 32'b00000000000000000000000000000100;

	// PC
	flopenr #(32) pcreg(
		clk,
		reset,
		PCWrite,
		Result,
		PC
	);

	mux2 #(32) instruct(
		PC,
		ALUOut,
		{2{AdrSrc}},
		Adr
	);

	flopenr #(32) datos(
		clk,
		reset,
		IRWrite,
		ReadData,
		Instr
	);

	//// DATA FROM MEMORY (LDR)
	flopr #(32) data_from_memory(
		clk,
		reset,
		ReadData,
		Data
	);

		mux2 #(4) ra1mux(
		.d0(Instr[19:16]),
		.d1(4'b1111),
		.s({2{RegSrc[0]}}),
		.y(RA1)
	);
		
	mux2 #(4) ra2mux(
		.d0(Instr[3:0]),
		.d1(Instr[15:12]),
		.s({2{RegSrc[1]}}),
		.y(RA2)
	);

	regfile rf(
		.clk(clk),
		.we3(RegWrite),
		.ra1(RA1),
		.ra2(RA2),
		.wa3(Instr[15:12]),
		.wd3(Result),
		.r15(Result),
		.rd1(RD1),
		.rd2(RD2)
	);

	flopr #(32) r1(
		clk,
		reset,
		RD1,
		A
	);

	flopr #(32) r2(
		clk,
		reset,
		RD2,
		WriteData
	);
	
	mux2 #(32) muxALUSrcA(
		A,
		PC,
		ALUSrcA,
		SrcA
	);


	/////// SrcA




	///// REGFILE Y IMMEDIATE



	extend ext(
		.Instr(Instr[23:0]),
		.ImmSrc(ImmSrc),
		.ExtImm(ExtImm)
	);

	/////// SrcB





	mux3 #(32) muxALUSrcB(
		WriteData,
		ExtImm,
		32'b00000000000000000000000000000100,
		ALUSrcB,
		SrcB
	);

	//////ALU
	ALU ALU(
		.a (SrcA),
		.b (SrcB),
		.ALUControl (ALUControl),
		.Result (ALUResult),
		.ALUFlags (ALUFlags)
	);

	/////// FINISH ALU
	flopr #(32) ALUflopr(
		clk,
		reset,
		ALUResult,
		ALUOut
	);
	mux3 #(32) muxResult(
		ALUOut,
		Data,
		ALUResult,
		ResultSrc,
		Result
	);

endmodule

//change