
This project shows that if we give const 512 bit data to sha256-transform function then 
quartus will calculate sha256 result and eliminates ALL logic.
Number of logical functions is zero but output pins connected to VCC or GND giving proper sha256 result.

See picture quartus-calcs-sha256.png



