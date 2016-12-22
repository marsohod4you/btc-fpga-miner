#!/usr/bin/tclsh

proc read_rpt { i frpt } {
set fp [open "output_files/xxx.map.summary" r]
set file_data [read $fp]
close $fp
set data [split $file_data "\n"]
foreach line $data {
set half [split $line ":"]
set a [lindex $half 0]
set b [lindex $half 1]
if { $a == "    Total combinational functions " } {
puts [format "%d %s" $i $b]
puts $frpt [format "%d %s" $i $b]
}
}
}

proc gen_sha256_src { i } {
set fo [open "sha256_test.v" "w"] 
puts $fo "module sha256_test("
puts $fo "	input wire clk,"
puts $fo "	input wire data,"
puts $fo "	output wire result"
puts $fo ");"
puts $fo ""
puts $fo "reg \[511:0]d;"
puts $fo "always @(posedge clk)"
puts $fo "	d <= { d\[510:0],data };"
puts $fo ""
puts $fo "wire \[255:0]r;"
puts $fo "sha256_transform s0("
puts $fo "		.state_in( 256'h5be0cd191f83d9ab9b05688c510e527fa54ff53a3c6ef372bb67ae856a09e667 ),"
puts $fo "		.data_in( d ),"
puts $fo "		.state_out(r)"
puts $fo "	);"
puts $fo ""
puts $fo "assign result = r\[$i];"
puts $fo ""
puts $fo "endmodule"
close $fo
}

set frpt [open "rpt.txt" "w"] 
for {set i 0} {$i < 256} {incr i} {
 gen_sha256_src $i
 exec x.bat
 read_rpt $i $frpt
}
close $frpt
exit
