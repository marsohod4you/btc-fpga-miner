module sha256_test(
	input wire clk,
	input wire data,
	output wire [255:0]result
);

reg [511:0]d;
always @(posedge clk)
	d <= { d[510:0],data };

sha256_transform s0(
		.state_in( 256'h5be0cd191f83d9ab9b05688c510e527fa54ff53a3c6ef372bb67ae856a09e667 ),
		.data_in( d ),
		.state_out(result)
	);

endmodule
