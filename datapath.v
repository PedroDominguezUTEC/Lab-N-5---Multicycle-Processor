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

	// Your datapath hardware goes below. Instantiate each of the 
	// submodules that you need. Remember that you can reuse hardware
	// from previous labs. Be sure to give your instantiated modules 
	// applicable names such as pcreg (PC register), adrmux 
	// (Address Mux), etc. so that your code is easier to understand.

	// ADD CODE HERE


	// PC
	flopenr pcreg(
		clk,
		reset,
		PCWrite,
		PCNext,
		PC
	);

	mux2 #(32) instruct(
		PC,
		Result,
		AdrSrc,
		Adr,
	);

	flopenr datos(
		clk,
		reset,
		IRWrite,
		ReadData,
		Instr
	);

	//// DATA FROM MEMORY (LDR)
	flopr data_from_memory(
		clk,
		reset,
		ReadData,
		Instr
	);

	/////// SrcA
	mux2 #(4) ra1mux(
		.d0(Instr[19:16]),
		.d1(4'b1111),
		.s(RegSrc[0]),
		.y(RA1)
	);

	flopr r1(
		clk,
		reset,
		RD1,
		A
	);

	mux2 #(32) muxALUSrcA(
		PC,
		A,
		ALUSrcA,
		SrcA
	);

	/////// SrcB

	mux2 #(4) ra2mux(
		.d0(Instr[3:0]),
		.d1(Instr[15:12]),
		.s(RegSrc[1]),
		.y(RA2)
	);

	flopr r2(
		clk,
		reset,
		RD2,
		WriteData
	);


	mux3 #(32) muxALUSrcB(
		WriteData,
		ExtImm,
		PC4,
		ALUSrcB,
		SrcB
	);

	//////ALU
	alu alu(
		.SrcA (SrcA),
		.SrcB (SrcB),
		.ALUControl (ALUControl),
		.Result (ALUResult),
		.ALUFlags (ALUFlags)
	);


	/////// FINISH ALU
	flopr ALUflopr(
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