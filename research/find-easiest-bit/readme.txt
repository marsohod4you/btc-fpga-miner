
This project allows to find SHA256 digest bit which is easiest to calculate,
which requires less number of logic elements.

Just run from command line:

>quartus_sh -t loop.sh

and wait for some hours.
Script generates top module for SHA256 transform but makes output of single digest bit.
From compilation report extract Total Number of combinatorial functions - this is complexity of output bit.

Conclusion: easiest output bit is number 224 (27204 LEs)

