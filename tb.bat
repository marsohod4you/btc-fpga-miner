iverilog -o qqq -DSIM=1 test_fpgaminer_top.v fpgaminer_top.v sha256_transform.v sha-256-functions.v serial.v async.v
REM vvp qqq
