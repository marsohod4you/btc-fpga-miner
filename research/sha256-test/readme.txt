
This project allows to compare verilog sha256 -transform implementation and C/C++ implementation.
Be sure verilog version works properly.

For run testbench use "iverilog". In command line run:
>iverilog -o qqq tb.v sha256.v
>vvp qqq
>gtkwave tb.vcd

Consider output signal "result".

With Visual Studio open solution "hash.sln"
Debug it to see printed output.

Both verilog and c++ programs calculate sha256 transform from hex data:
512'h66656463626139383736353433323130666564636261393837363534333231306665646362613938373635343332313066656463626139383736353433323130;

or string 
const u8 str[] = "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef";
which is same.

Compare result is equal.
See picture compare-cpp-verilog.png
