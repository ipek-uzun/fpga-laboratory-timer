# Laboratory Timer on Tang Nano 9K

A laboratory countdown timer designed as a full schematic digital circuit and implemented on the Tang Nano 9K FPGA

## Features
- MM timer display
- Configurable start time from 00:01 to 99:59
- Individual digit adjustment in SET mode
- Countdown operation in RUN mode
- Automatically switches to overtime counting after reaching 00:00
- Uses a 1 Hz pulse as the time base
- Sequential design using flip-flops and combinational logic
- Designed without clock gating
- Compatible with the Tang Nano 9K FPGA

  The completed schematic can be exported to Verilog and programmed onto the Tang Nano 9K using the provided Verilog template.
