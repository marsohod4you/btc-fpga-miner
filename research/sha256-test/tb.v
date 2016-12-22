`timescale 1ns/1ps

module tb;

	initial
	begin
		$dumpfile("tb.vcd");
		$dumpvars(0, tb);
		#100;
		$finish;
	end
	
	wire [511:0]data;
	
	assign data = 512'h66656463626139383736353433323130666564636261393837363534333231306665646362613938373635343332313066656463626139383736353433323130;
	
	wire [255:0]result;
	sha256_transform s(
		.state_in( 256'h5be0cd191f83d9ab9b05688c510e527fa54ff53a3c6ef372bb67ae856a09e667 ),
		.data_in(data),
		.state_out(result)
	);
	
endmodule

