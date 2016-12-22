
module e0 (x, y);
	input [31:0] x;
	output [31:0] y;
	assign y = {x[1:0],x[31:2]} ^ {x[12:0],x[31:13]} ^ {x[21:0],x[31:22]};
endmodule

module e1 (x, y);
	input [31:0] x;
	output [31:0] y;
	assign y = {x[5:0],x[31:6]} ^ {x[10:0],x[31:11]} ^ {x[24:0],x[31:25]};
endmodule

module ch (x, y, z, o);
	input [31:0] x, y, z;
	output [31:0] o;
	assign o = z ^ (x & (y ^ z));
endmodule

module maj (x, y, z, o);
	input [31:0] x, y, z;
	output [31:0] o;
	assign o = (x & y) | (z & (x | y));
endmodule

module s0 (x, y);
	input [31:0] x;
	output [31:0] y;
	assign y[31:29] = x[6:4] ^ x[17:15];
	assign y[28:0] = {x[3:0], x[31:7]} ^ {x[14:0],x[31:18]} ^ x[31:3];
endmodule

module s1 (x, y);
	input [31:0] x;
	output [31:0] y;
	assign y[31:22] = x[16:7] ^ x[18:9];
	assign y[21:0] = {x[6:0],x[31:17]} ^ {x[8:0],x[31:19]} ^ x[31:10];
endmodule

module round (idx, in, k, w, out);
	input  [7:0]idx;
	input  [255:0]in;
	input  [ 31:0]k;
	input  [ 31:0]w;
	output [255:0]out;
	
	always @(w)
		$display("i=%d k=%8x w=%8x",idx,k,w);
	
	wire [31:0]a; assign a = in[ 31:  0];
	wire [31:0]b; assign b = in[ 63: 32];
	wire [31:0]c; assign c = in[ 95: 64];
	wire [31:0]d; assign d = in[127: 96];
	wire [31:0]e; assign e = in[159:128];
	wire [31:0]f; assign f = in[191:160];
	wire [31:0]g; assign g = in[223:192];
	wire [31:0]h; assign h = in[255:224];
	
	wire [31:0]e0_w; e0 e0_(a,e0_w);
	wire [31:0]e1_w; e1 e1_(e,e1_w);
	wire [31:0]ch_w; ch ch_(e,f,g,ch_w);
	wire [31:0]mj_w; maj maj_(a,b,c,mj_w);
	
	wire [31:0]t1; assign t1 = h+w+k+ch_w+e1_w;
	wire [31:0]t2; assign t2 = mj_w+e0_w;
	wire [31:0]a_; assign a_ = t1+t2;
	wire [31:0]d_; assign d_ = d+t1;
	assign out = { g,f,e,d_,c,b,a,a_ };
endmodule

module sha256_transform(
	input  wire [255:0]state_in,
	input  wire [511:0]data_in,
	output wire [255:0]state_out
);
	localparam Ks = {
		32'h428a2f98, 32'h71374491, 32'hb5c0fbcf, 32'he9b5dba5,
		32'h3956c25b, 32'h59f111f1, 32'h923f82a4, 32'hab1c5ed5,
		32'hd807aa98, 32'h12835b01, 32'h243185be, 32'h550c7dc3,
		32'h72be5d74, 32'h80deb1fe, 32'h9bdc06a7, 32'hc19bf174,
		32'he49b69c1, 32'hefbe4786, 32'h0fc19dc6, 32'h240ca1cc,
		32'h2de92c6f, 32'h4a7484aa, 32'h5cb0a9dc, 32'h76f988da,
		32'h983e5152, 32'ha831c66d, 32'hb00327c8, 32'hbf597fc7,
		32'hc6e00bf3, 32'hd5a79147, 32'h06ca6351, 32'h14292967,
		32'h27b70a85, 32'h2e1b2138, 32'h4d2c6dfc, 32'h53380d13,
		32'h650a7354, 32'h766a0abb, 32'h81c2c92e, 32'h92722c85,
		32'ha2bfe8a1, 32'ha81a664b, 32'hc24b8b70, 32'hc76c51a3,
		32'hd192e819, 32'hd6990624, 32'hf40e3585, 32'h106aa070,
		32'h19a4c116, 32'h1e376c08, 32'h2748774c, 32'h34b0bcb5,
		32'h391c0cb3, 32'h4ed8aa4a, 32'h5b9cca4f, 32'h682e6ff3,
		32'h748f82ee, 32'h78a5636f, 32'h84c87814, 32'h8cc70208,
		32'h90befffa, 32'ha4506ceb, 32'hbef9a3f7, 32'hc67178f2};

	genvar i;
	generate
	for(i=0; i<64; i=i+1)
	begin : RND
			wire [255:0] state;
			wire [31:0]W;
			
			if(i<16)
			begin
				assign W = data_in[i*32+31:i*32];
			end
			else
			begin
				wire [31:0]s0_w; s0 so_(RND[i-15].W,s0_w);
				wire [31:0]s1_w; s1 s1_(RND[i-2].W,s1_w);
				assign W = s1_w + RND[i - 7].W + s0_w + RND[i - 16].W;
			end
			
			if(i == 0)
				round R (
					.idx(i[7:0]),
					.in(state_in),
					.k( Ks[32*(63-i)+31:32*(63-i)] ),
					.w(W),
					.out(state) );
			else
				round R (
					.idx(i[7:0]),
					.in(RND[i-1].state),
					.k( Ks[32*(63-i)+31:32*(63-i)] ),
					.w(W),
					.out(state) );
	end
	endgenerate

	wire [31:0]a; assign a = state_in[ 31:  0];
	wire [31:0]b; assign b = state_in[ 63: 32];
	wire [31:0]c; assign c = state_in[ 95: 64];
	wire [31:0]d; assign d = state_in[127: 96];
	wire [31:0]e; assign e = state_in[159:128];
	wire [31:0]f; assign f = state_in[191:160];
	wire [31:0]g; assign g = state_in[223:192];
	wire [31:0]h; assign h = state_in[255:224];

	wire [31:0]a1; assign a1 = RND[63].state[ 31:  0];
	wire [31:0]b1; assign b1 = RND[63].state[ 63: 32];
	wire [31:0]c1; assign c1 = RND[63].state[ 95: 64];
	wire [31:0]d1; assign d1 = RND[63].state[127: 96];
	wire [31:0]e1; assign e1 = RND[63].state[159:128];
	wire [31:0]f1; assign f1 = RND[63].state[191:160];
	wire [31:0]g1; assign g1 = RND[63].state[223:192];
	wire [31:0]h1; assign h1 = RND[63].state[255:224];	

	wire [31:0]a2; assign a2 = a+a1;
	wire [31:0]b2; assign b2 = b+b1;
	wire [31:0]c2; assign c2 = c+c1;
	wire [31:0]d2; assign d2 = d+d1;
	wire [31:0]e2; assign e2 = e+e1;
	wire [31:0]f2; assign f2 = f+f1;
	wire [31:0]g2; assign g2 = g+g1;
	wire [31:0]h2; assign h2 = h+h1;
	
	assign state_out = {h2,g2,f2,e2,d2,c2,b2,a2};
	
endmodule

