module mem (
	clk,
	we,
	a,
	wd,
	rd
);

	input wire clk;
	input wire we;
	input wire [31:0] a;
	input wire [31:0] wd;
	output wire [31:0] rd;
	reg [31:0] RAM [0:22];
	initial $readmemh("memfile.dat", RAM);	
	assign rd = RAM[a[31:2]];
	
	always @(posedge clk)
		if (we)
			RAM[a[31:2]] <= wd;
endmodule