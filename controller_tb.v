`include "arm_multi.v"
`timescale 1ns/1ns

module testbench();
	reg clk;
	reg reset;
	reg [3:0] ALUFlags;
	wire MemWrite;
	wire RegWrite;
	wire IRWrite;
	wire AdrSrc;
	wire [1:0] RegSrc;
	wire [1:0] ALUSrcA;
	wire [1:0] ALUSrcB;
	wire [1:0] ResultSrc;
	wire [1:0] ImmSrc;
	wire [1:0] ALUControl;
	
	reg [31:0] Instr;
	
	controller dut(
		.clk(clk),
		.reset(reset),
		.Instr(Instr[31:12]),
		.ALUFlags(ALUFlags),
		.PCWrite(PCWrite),
		.MemWrite(MemWrite),
		.RegWrite(RegWrite),
		.IRWrite(IRWrite),
		.AdrSrc(AdrSrc),
		.RegSrc(RegSrc),
		.ALUSrcA(ALUSrcA),
		.ALUSrcB(ALUSrcB),
		.ResultSrc(ResultSrc),
		.ImmSrc(ImmSrc),
		.ALUControl(ALUControl)
	);

	initial begin
		reset <= 1;
    	#(1);
		reset <= 0;
	end
  
	always begin
		clk <= 1;
		#(1);
		clk <= 0;
		#(1);
	end
  
	initial begin
	//And
	#(1);
	Instr = 32'b11100010100000000010000000000001;
	ALUFlags = 0000;
	#(10);

	//Branch
	Instr = 32'b11101010000000000000000000000001;
	ALUFlags = 4'b0011;

	#(10);

	//Load
	Instr = 32'b11100101100100000010000001100000;
	ALUFlags = 0011;

	#(10);

	//Store
	Instr = 32'b11100101100000000010000001010100;
	#(10);

	$finish;
	end
    
	initial
    	begin
        $dumpfile("multicycle.vcd");
  		$dumpvars;
    end
endmodule