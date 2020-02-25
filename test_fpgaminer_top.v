// Testbench for fpgaminer_top.v

`timescale 1ns/1ps

module test_fpgaminer_top ();

	reg clk = 1'b0;
	reg RxD = 1'b1;	// Active low
	wire [7:0]led_out;
	wire TxD;
	
	fpgaminer_top uut (clk, RxD, TxD, led_out);

	reg [31:0] cycle = 32'd0;

	initial begin
		//$dumpfile("out.vcd");
		//$dumpvars(0, test_fpgaminer_top);
		
		clk = 0;

		#100
		// v9 test of work_BAD_30d9da77 from cpuhash on tvpi (see reversehex.cpp)
		// NB BUGGY code gives golden nonce 30d9da77 however correct nonce is 30d9db77 (0x100 larger)
		//  ... NOT a FULL test of the fix, more cases are required (including the ORIGINAL reference case below)
		//      but this will do for now (will test it in live FPGA ... lazy!!)
		
		// C:\altera\MJ-Projects\EP4CE10_Hashers_11_Serial>reversehex
		// e1531a6da87888e644e1f97c0389de5e51a3d2a73117c0988a7c51ecd58085d2
		// 00000280000000000000000000000000000000000000000000000000000000000000000000000000000000008000000000000000be2f021aa0726351545aad2efc84ba489a8b2c067d05a0c6b490d43a0aaeecf3c4b62c3f0ce24ee900000000d9010000294057cea20385f349ff27265dcd9ca4bc1ae704784ca88802000000

	//	uut.midstate_buf = 256'he1531a6da87888e644e1f97c0389de5e51a3d2a73117c0988a7c51ecd58085d2;
		// data_buf is actually 256 or 96 bits, but no harm giving 512 here (its truncated as appropriate)
	//	uut.data_buf = 512'h00000280000000000000000000000000000000000000000000000000000000000000000000000000000000008000000000000000be2f021aa0726351545aad2e;

		// NB We simulate CORRECT golden nonce 30d9db77 (BUGGY code will report golden nonce 30d9da77, ie 0x100 less)
	//	uut.nonce = 32'h30d9db77 - 3;	// fullhash flag at 1560nS and golden_nonce 30d9db77 at 1570nS
		

		// ====================================================================================================
		
		// ORIGINAL Test data (v5 and later) ...
		//uut.midstate_buf = 256'h85a24391639705f42f64b3b688df3d147445123c323e62143d87e1908b3f07ef;
		// data_buf is actually 256 or 96 bits, but no harm giving 512 here (its truncated as appropriate)
		//uut.data_buf = //512'h00000280000000000000000000000000000000000000000000000000000000000000000000000000000000008000000000000000c513051a02a99050bfec0373;
		
		// v5 results ...
		// uut.nonce = 32'h1afda099;	// NO MATCH, but we do see nonce_lsb output for 99
										// Perhaps data and nonce_lsb are out of sync?
										// Or maybe midstate has not fully propagated yet (more likely)
		// uut.nonce = 32'h1afda098;	// fullhash flag at 1540nS and golden_nonce 1afda099 at 1550nS
		// uut.nonce = 32'h1afda097;	// fullhash flag at 1550nS and golden_nonce 1afda099 at 1560nS
		// uut.nonce = 32'h1afda096;	// fullhash flag at 1560nS and golden_nonce 1afda099 at 1570nS [REFERENCE nonce]
		// uut.nonce = 32'h1afda095;	// fullhash flag at 1570nS and golden_nonce 1afda099 at 1580nS
		// uut.nonce = 32'h1afda090;	// fullhash flag at 1620nS and golden_nonce 1afda099 at 1630nS
		// uut.nonce = 32'h1afda08f;	// fullhash flag at 1630nS and golden_nonce 1afda099 at 1640nS
		// uut.nonce = 32'h1afda08e;	// fullhash flag at 1630nS and golden_nonce 1afda099 at 1640nS
		// uut.nonce = 32'h1afda08d;	// fullhash flag at 2970nS and golden_nonce 1afda099 at 2980nS
		// uut.nonce = 32'h1afda08c;	// fullhash flag at 2980nS and golden_nonce 1afda099 at 2890nS
		// uut.nonce = 32'h1afda08b;	// fullhash flag at 2990nS and golden_nonce 1afda099 at 3000nS
		
		
		//block #286819 
		//https://www.blockchain.com/btc/block/286819
		//https://habr.com/ru/post/258181/
		//hash: 502A989242BDFA912DA58A972836C9CDFEDD4A0278A467E00000000000000000
		/*
		uint8_t str[] = {
		0x02,0x00,0x00,0x00,
		0x17,0x97,0x5b,0x97,0xc1,0x8e,0xd1,0xf7,
		0xe2,0x55,0xad,0xf2,0x97,0x59,0x9b,0x55,
		0x33,0x0e,0xda,0xb8,0x78,0x03,0xc8,0x17,
		0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
		0x8a,0x97,0x29,0x5a,0x27,0x47,0xb4,0xf1,
		0xa0,0xb3,0x94,0x8d,0xf3,0x99,0x03,0x44,
		0xc0,0xe1,0x9f,0xa6,0xb2,0xb9,0x2b,0x3a,
		0x19,0xc8,0xe6,0xba,
		0xdc,0x14,0x17,0x87,
		0x35,0x8b,0x05,0x53,
		0x53,0x5f,0x01,0x19,
		0x48,0x75,0x08,0x33 //nonce 4 bytes!
		};
		*/
		uut.midstate_buf = 256'hFC48D2DF95F0172E4CBB9B8FC3C1B9E4E536F7D5CB1A54340C69421ADC6A3B8D;
		uut.data_buf = 512'h00000280000000000000000000000000000000000000000000000000000000000000000000000000000000008000000048750833535F0119358B0553DC141787;
		uut.nonce = 32'h48750400;
		
		while(1)
		begin
			#5 clk = 1; #5 clk = 0;
		end
	end


	always @ (posedge clk)
	begin
		cycle <= cycle + 32'd1;
	end

	always @(posedge uut.serial_send)
	begin
		$display ("GOLDEN nonce: %8x\n", uut.golden_nonce);
		$finish();
	end
	
	always @ (posedge clk)
	begin
		$display ("*000: %64x", uut.uut.HASHERS[0].genblk16.U.tx_state );
		$display ("*001: %64x", uut.uut.HASHERS[1].genblk17.U.tx_state );
		$display ("*002: %64x", uut.uut.HASHERS[2].genblk17.U.tx_state );
		$display ("*003: %64x", uut.uut.HASHERS[3].genblk17.U.tx_state );
		$display ("*004: %64x", uut.uut.HASHERS[4].genblk17.U.tx_state );
		$display ("*005: %64x", uut.uut.HASHERS[5].genblk17.U.tx_state );
		$display ("*006: %64x", uut.uut.HASHERS[6].genblk17.U.tx_state );
		$display ("*007: %64x", uut.uut.HASHERS[7].genblk17.U.tx_state );
		$display ("*008: %64x", uut.uut.HASHERS[8].genblk17.U.tx_state );
		$display ("*009: %64x", uut.uut.HASHERS[9].genblk17.U.tx_state );
		$display ("*010: %64x", uut.uut.HASHERS[10].genblk17.U.tx_state );
		$display ("*011: %64x", uut.uut.HASHERS[11].genblk17.U.tx_state );
		$display ("*012: %64x", uut.uut.HASHERS[12].genblk17.U.tx_state );
		$display ("*013: %64x", uut.uut.HASHERS[13].genblk17.U.tx_state );
		$display ("*014: %64x", uut.uut.HASHERS[14].genblk17.U.tx_state );
		$display ("*015: %64x", uut.uut.HASHERS[15].genblk17.U.tx_state );
		$display ("*016: %64x", uut.uut.HASHERS[16].genblk17.U.tx_state );
		$display ("*017: %64x", uut.uut.HASHERS[17].genblk17.U.tx_state );
		$display ("*018: %64x", uut.uut.HASHERS[18].genblk17.U.tx_state );
		$display ("*019: %64x", uut.uut.HASHERS[19].genblk17.U.tx_state );
		$display ("*020: %64x", uut.uut.HASHERS[20].genblk17.U.tx_state );
		$display ("*021: %64x", uut.uut.HASHERS[21].genblk17.U.tx_state );
		$display ("*022: %64x", uut.uut.HASHERS[22].genblk17.U.tx_state );
		$display ("*023: %64x", uut.uut.HASHERS[23].genblk17.U.tx_state );
		$display ("*024: %64x", uut.uut.HASHERS[24].genblk17.U.tx_state );
		$display ("*025: %64x", uut.uut.HASHERS[25].genblk17.U.tx_state );
		$display ("*026: %64x", uut.uut.HASHERS[26].genblk17.U.tx_state );
		$display ("*027: %64x", uut.uut.HASHERS[27].genblk17.U.tx_state );
		$display ("*028: %64x", uut.uut.HASHERS[28].genblk17.U.tx_state );
		$display ("*029: %64x", uut.uut.HASHERS[29].genblk17.U.tx_state );
		$display ("*030: %64x", uut.uut.HASHERS[30].genblk17.U.tx_state );
		$display ("*031: %64x", uut.uut.HASHERS[31].genblk17.U.tx_state );
		$display ("*032: %64x", uut.uut.HASHERS[32].genblk17.U.tx_state );
		$display ("*033: %64x", uut.uut.HASHERS[33].genblk17.U.tx_state );
		$display ("*034: %64x", uut.uut.HASHERS[34].genblk17.U.tx_state );
		$display ("*035: %64x", uut.uut.HASHERS[35].genblk17.U.tx_state );
		$display ("*036: %64x", uut.uut.HASHERS[36].genblk17.U.tx_state );
		$display ("*037: %64x", uut.uut.HASHERS[37].genblk17.U.tx_state );
		$display ("*038: %64x", uut.uut.HASHERS[38].genblk17.U.tx_state );
		$display ("*039: %64x", uut.uut.HASHERS[39].genblk17.U.tx_state );
		$display ("*040: %64x", uut.uut.HASHERS[40].genblk17.U.tx_state );
		$display ("*041: %64x", uut.uut.HASHERS[41].genblk17.U.tx_state );
		$display ("*042: %64x", uut.uut.HASHERS[42].genblk17.U.tx_state );
		$display ("*043: %64x", uut.uut.HASHERS[43].genblk17.U.tx_state );
		$display ("*044: %64x", uut.uut.HASHERS[44].genblk17.U.tx_state );
		$display ("*045: %64x", uut.uut.HASHERS[45].genblk17.U.tx_state );
		$display ("*046: %64x", uut.uut.HASHERS[46].genblk17.U.tx_state );
		$display ("*047: %64x", uut.uut.HASHERS[47].genblk17.U.tx_state );
		$display ("*048: %64x", uut.uut.HASHERS[48].genblk17.U.tx_state );
		$display ("*049: %64x", uut.uut.HASHERS[49].genblk17.U.tx_state );
		$display ("*050: %64x", uut.uut.HASHERS[50].genblk17.U.tx_state );
		$display ("*051: %64x", uut.uut.HASHERS[51].genblk17.U.tx_state );
		$display ("*052: %64x", uut.uut.HASHERS[52].genblk17.U.tx_state );
		$display ("*053: %64x", uut.uut.HASHERS[53].genblk17.U.tx_state );
		$display ("*054: %64x", uut.uut.HASHERS[54].genblk17.U.tx_state );
		$display ("*055: %64x", uut.uut.HASHERS[55].genblk17.U.tx_state );
		$display ("*056: %64x", uut.uut.HASHERS[56].genblk17.U.tx_state );
		$display ("*057: %64x", uut.uut.HASHERS[57].genblk17.U.tx_state );
		$display ("*058: %64x", uut.uut.HASHERS[58].genblk17.U.tx_state );
		$display ("*059: %64x", uut.uut.HASHERS[59].genblk17.U.tx_state );
		$display ("*060: %64x", uut.uut.HASHERS[60].genblk17.U.tx_state );
		$display ("*061: %64x", uut.uut.HASHERS[61].genblk17.U.tx_state );
		$display ("*062: %64x", uut.uut.HASHERS[62].genblk17.U.tx_state );
		$display ("*063: %64x", uut.uut.HASHERS[63].genblk17.U.tx_state );
		
		$display ("*100: %64x", uut.uut2.HASHERS[0].genblk16.U.tx_state );
		$display ("*101: %64x", uut.uut2.HASHERS[1].genblk17.U.tx_state );
		$display ("*102: %64x", uut.uut2.HASHERS[2].genblk17.U.tx_state );
		$display ("*103: %64x", uut.uut2.HASHERS[3].genblk17.U.tx_state );
		$display ("*104: %64x", uut.uut2.HASHERS[4].genblk17.U.tx_state );
		$display ("*105: %64x", uut.uut2.HASHERS[5].genblk17.U.tx_state );
		$display ("*106: %64x", uut.uut2.HASHERS[6].genblk17.U.tx_state );
		$display ("*107: %64x", uut.uut2.HASHERS[7].genblk17.U.tx_state );
		$display ("*108: %64x", uut.uut2.HASHERS[8].genblk17.U.tx_state );
		$display ("*109: %64x", uut.uut2.HASHERS[9].genblk17.U.tx_state );
		$display ("*110: %64x", uut.uut2.HASHERS[10].genblk17.U.tx_state );
		$display ("*111: %64x", uut.uut2.HASHERS[11].genblk17.U.tx_state );
		$display ("*112: %64x", uut.uut2.HASHERS[12].genblk17.U.tx_state );
		$display ("*113: %64x", uut.uut2.HASHERS[13].genblk17.U.tx_state );
		$display ("*114: %64x", uut.uut2.HASHERS[14].genblk17.U.tx_state );
		$display ("*115: %64x", uut.uut2.HASHERS[15].genblk17.U.tx_state );
		$display ("*116: %64x", uut.uut2.HASHERS[16].genblk17.U.tx_state );
		$display ("*117: %64x", uut.uut2.HASHERS[17].genblk17.U.tx_state );
		$display ("*118: %64x", uut.uut2.HASHERS[18].genblk17.U.tx_state );
		$display ("*119: %64x", uut.uut2.HASHERS[19].genblk17.U.tx_state );
		$display ("*120: %64x", uut.uut2.HASHERS[20].genblk17.U.tx_state );
		$display ("*121: %64x", uut.uut2.HASHERS[21].genblk17.U.tx_state );
		$display ("*122: %64x", uut.uut2.HASHERS[22].genblk17.U.tx_state );
		$display ("*123: %64x", uut.uut2.HASHERS[23].genblk17.U.tx_state );
		$display ("*124: %64x", uut.uut2.HASHERS[24].genblk17.U.tx_state );
		$display ("*125: %64x", uut.uut2.HASHERS[25].genblk17.U.tx_state );
		$display ("*126: %64x", uut.uut2.HASHERS[26].genblk17.U.tx_state );
		$display ("*127: %64x", uut.uut2.HASHERS[27].genblk17.U.tx_state );
		$display ("*128: %64x", uut.uut2.HASHERS[28].genblk17.U.tx_state );
		$display ("*129: %64x", uut.uut2.HASHERS[29].genblk17.U.tx_state );
		$display ("*130: %64x", uut.uut2.HASHERS[30].genblk17.U.tx_state );
		$display ("*131: %64x", uut.uut2.HASHERS[31].genblk17.U.tx_state );
		$display ("*132: %64x", uut.uut2.HASHERS[32].genblk17.U.tx_state );
		$display ("*133: %64x", uut.uut2.HASHERS[33].genblk17.U.tx_state );
		$display ("*134: %64x", uut.uut2.HASHERS[34].genblk17.U.tx_state );
		$display ("*135: %64x", uut.uut2.HASHERS[35].genblk17.U.tx_state );
		$display ("*136: %64x", uut.uut2.HASHERS[36].genblk17.U.tx_state );
		$display ("*137: %64x", uut.uut2.HASHERS[37].genblk17.U.tx_state );
		$display ("*138: %64x", uut.uut2.HASHERS[38].genblk17.U.tx_state );
		$display ("*139: %64x", uut.uut2.HASHERS[39].genblk17.U.tx_state );
		$display ("*140: %64x", uut.uut2.HASHERS[40].genblk17.U.tx_state );
		$display ("*141: %64x", uut.uut2.HASHERS[41].genblk17.U.tx_state );
		$display ("*142: %64x", uut.uut2.HASHERS[42].genblk17.U.tx_state );
		$display ("*143: %64x", uut.uut2.HASHERS[43].genblk17.U.tx_state );
		$display ("*144: %64x", uut.uut2.HASHERS[44].genblk17.U.tx_state );
		$display ("*145: %64x", uut.uut2.HASHERS[45].genblk17.U.tx_state );
		$display ("*146: %64x", uut.uut2.HASHERS[46].genblk17.U.tx_state );
		$display ("*147: %64x", uut.uut2.HASHERS[47].genblk17.U.tx_state );
		$display ("*148: %64x", uut.uut2.HASHERS[48].genblk17.U.tx_state );
		$display ("*149: %64x", uut.uut2.HASHERS[49].genblk17.U.tx_state );
		$display ("*150: %64x", uut.uut2.HASHERS[50].genblk17.U.tx_state );
		$display ("*151: %64x", uut.uut2.HASHERS[51].genblk17.U.tx_state );
		$display ("*152: %64x", uut.uut2.HASHERS[52].genblk17.U.tx_state );
		$display ("*153: %64x", uut.uut2.HASHERS[53].genblk17.U.tx_state );
		$display ("*154: %64x", uut.uut2.HASHERS[54].genblk17.U.tx_state );
		$display ("*155: %64x", uut.uut2.HASHERS[55].genblk17.U.tx_state );
		$display ("*156: %64x", uut.uut2.HASHERS[56].genblk17.U.tx_state );
		$display ("*157: %64x", uut.uut2.HASHERS[57].genblk17.U.tx_state );
		$display ("*158: %64x", uut.uut2.HASHERS[58].genblk17.U.tx_state );
		$display ("*159: %64x", uut.uut2.HASHERS[59].genblk17.U.tx_state );
		$display ("*160: %64x", uut.uut2.HASHERS[60].genblk17.U.tx_state );
		$display ("*161: %64x", uut.uut2.HASHERS[61].genblk17.U.tx_state );
		$display ("*162: %64x", uut.uut2.HASHERS[62].genblk17.U.tx_state );
		$display ("*163: %64x", uut.uut2.HASHERS[63].genblk17.U.tx_state );
	end
		
endmodule

