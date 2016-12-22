/*

//--------------------------------------------------------------
//single instance of sha256_transform

module sha256_test(
	input wire clk,
	input wire data,
	output wire result
);

reg [511:0]d;
always @(posedge clk)
	d <= { d[510:0],data };

wire [255:0]r;
sha256_transform s0(
		.state_in( 256'h5be0cd191f83d9ab9b05688c510e527fa54ff53a3c6ef372bb67ae856a09e667 ),
		.data_in( d ),
		.state_out(r)
	);

assign result = r[224];

endmodule

//Total combinational functions	27,204

*/

/*

//--------------------------------------------------------------
//double instance of sha256_transform

module sha256_test(
	input wire clk,
	input wire data,
	output wire [1:0]result
);

reg [511:0]d;
always @(posedge clk)
	d <= { d[510:0],data };

wire [255:0]r0;
sha256_transform s0(
		.state_in( 256'h5be0cd191f83d9ab9b05688c510e527fa54ff53a3c6ef372bb67ae856a09e667 ),
		.data_in( { 1'b0, d[510:0] } ),
		.state_out(r0)
	);

wire [255:0]r1;
sha256_transform s1(
		.state_in( 256'h5be0cd191f83d9ab9b05688c510e527fa54ff53a3c6ef372bb67ae856a09e667 ),
		.data_in( { 1'b1, d[510:0] } ),
		.state_out(r1)
	);

assign result = { r0[224], r1[224] };

endmodule

//Total combinational functions	47,805
//so per instance: 47805/2 = 23902

*/


/*
//----------------------------------------------------------------
//4 instances

module sha256_test(
	input wire clk,
	input wire data,
	output wire [3:0]result
);

reg [511:0]d;
always @(posedge clk)
	d <= { d[510:0],data };

wire [255:0]r0;
sha256_transform s0(
		.state_in( 256'h5be0cd191f83d9ab9b05688c510e527fa54ff53a3c6ef372bb67ae856a09e667 ),
		.data_in( { 2'b00, d[509:0] } ),
		.state_out(r0)
	);

wire [255:0]r1;
sha256_transform s1(
		.state_in( 256'h5be0cd191f83d9ab9b05688c510e527fa54ff53a3c6ef372bb67ae856a09e667 ),
		.data_in( { 2'b01, d[509:0] } ),
		.state_out(r1)
	);

wire [255:0]r2;
sha256_transform s2(
		.state_in( 256'h5be0cd191f83d9ab9b05688c510e527fa54ff53a3c6ef372bb67ae856a09e667 ),
		.data_in( { 2'b10, d[509:0] } ),
		.state_out(r2)
	);

wire [255:0]r3;
sha256_transform s3(
		.state_in( 256'h5be0cd191f83d9ab9b05688c510e527fa54ff53a3c6ef372bb67ae856a09e667 ),
		.data_in( { 2'b11, d[509:0] } ),
		.state_out(r3)
	);

assign result = { r0[224], r1[224], r2[224], r3[224] };

endmodule

//Total combinational functions	89,009
//per instance: 89009/4=22252
*/

//----------------------------------------------------------------
//4 instances

module sha256_test(
	input wire clk,
	input wire data,
	output wire [7:0]result
);

reg [511:0]d;
always @(posedge clk)
	d <= { d[510:0],data };

wire [255:0]r0;
sha256_transform s0(
		.state_in( 256'h5be0cd191f83d9ab9b05688c510e527fa54ff53a3c6ef372bb67ae856a09e667 ),
		.data_in( { 3'b000, d[508:0] } ),
		.state_out(r0)
	);

wire [255:0]r1;
sha256_transform s1(
		.state_in( 256'h5be0cd191f83d9ab9b05688c510e527fa54ff53a3c6ef372bb67ae856a09e667 ),
		.data_in( { 3'b001, d[508:0] } ),
		.state_out(r1)
	);

wire [255:0]r2;
sha256_transform s2(
		.state_in( 256'h5be0cd191f83d9ab9b05688c510e527fa54ff53a3c6ef372bb67ae856a09e667 ),
		.data_in( { 3'b010, d[508:0] } ),
		.state_out(r2)
	);

wire [255:0]r3;
sha256_transform s3(
		.state_in( 256'h5be0cd191f83d9ab9b05688c510e527fa54ff53a3c6ef372bb67ae856a09e667 ),
		.data_in( { 3'b011, d[508:0] } ),
		.state_out(r3)
	);

wire [255:0]r4;
sha256_transform s4(
		.state_in( 256'h5be0cd191f83d9ab9b05688c510e527fa54ff53a3c6ef372bb67ae856a09e667 ),
		.data_in( { 3'b100, d[508:0] } ),
		.state_out(r4)
	);

wire [255:0]r5;
sha256_transform s5(
		.state_in( 256'h5be0cd191f83d9ab9b05688c510e527fa54ff53a3c6ef372bb67ae856a09e667 ),
		.data_in( { 3'b101, d[508:0] } ),
		.state_out(r5)
	);

wire [255:0]r6;
sha256_transform s6(
		.state_in( 256'h5be0cd191f83d9ab9b05688c510e527fa54ff53a3c6ef372bb67ae856a09e667 ),
		.data_in( { 3'b110, d[508:0] } ),
		.state_out(r6)
	);

wire [255:0]r7;
sha256_transform s7(
		.state_in( 256'h5be0cd191f83d9ab9b05688c510e527fa54ff53a3c6ef372bb67ae856a09e667 ),
		.data_in( { 3'b111, d[508:0] } ),
		.state_out(r7)
	);

assign result = { r0[224], r1[224], r2[224], r3[224], r4[224], r5[224], r6[224], r7[224] };

endmodule

//Total combinational functions	171,418
//171418/8=21427
