module top
(
    input        clk,
    input  [3:0] sw,
    input  [3:0] btn,
    output [7:0] led,
    output reg [7:0] seven,
    output reg [3:0] segment
);

  // --- sayaç verileri 4 bit ---
  wire [3:0] m10, m1, s10, s1;
  wire       HZ1;

  // --- buton / sw0 debounce ---
  wire b0, b1, b2, b3;
  wire sw0_db;
  
  debounce btn0(clk, btn[0], b0);
  debounce btn1(clk, btn[1], b1);
  debounce btn2(clk, btn[2], b2);
  debounce btn3(clk, btn[3], b3);
  debounce sw0 (clk, sw[0], sw0_db);

  // --- ana labtimer modülü ---
  labtimer tmr1(
    .clk  (clk),
    .SW   (sw0_db),
    .B3   (b3),
    .B2   (b2),
    .B1   (b1),
    .B0   (b0),
    .hz1  (HZ1),
    .M10  (m10),
    .M1   (m1),
    .S10  (s10),
    .S1   (s1)
  );

  // --- display için lookup ve sayaçlar ---
  reg [6:0]  hex2seven [0:15];
  reg [15:0] dispCounter = 0;
  reg [1:0]  segCounter  = 0;
  reg [24:0] divCounter  = 0;

  assign led = { sw, btn };
  assign HZ1 = (divCounter == 25'd26999999);

  initial begin
    hex2seven[0]  = 7'b0111111;
    hex2seven[1]  = 7'b0000110;
    hex2seven[2]  = 7'b1011011;
    hex2seven[3]  = 7'b1001111;
    hex2seven[4]  = 7'b1100110;
    hex2seven[5]  = 7'b1101101;
    hex2seven[6]  = 7'b1111101;
    hex2seven[7]  = 7'b0000111;
    hex2seven[8]  = 7'b1111111;
    hex2seven[9]  = 7'b1101111;
    hex2seven[10] = 7'b1110111;
    hex2seven[11] = 7'b1111100;
    hex2seven[12] = 7'b0111001;
    hex2seven[13] = 7'b1011110;
    hex2seven[14] = 7'b1111001;
    hex2seven[15] = 7'b1110001;
    segment = 4'b0001;
  end

  // --- hangi haneyi gösteriyoruz? ---
  always @(posedge clk) begin
    dispCounter <= dispCounter + 1;
    if (dispCounter == 0)
      segCounter <= segCounter + 1;
  end

  // --- 7-segment sürme ---
  always @(m10, m1, s10, s1, segCounter) begin
    case (segCounter)
      2'b00: begin seven <= {1'b0, hex2seven[s1]};  segment <= 4'b0001; end
      2'b01: begin seven <= {1'b0, hex2seven[s10]}; segment <= 4'b0010; end
      2'b10: begin seven <= {1'b1, hex2seven[m1]};  segment <= 4'b0100; end
      2'b11: begin seven <= {1'b0, hex2seven[m10]}; segment <= 4'b1000; end
    endcase
  end

  // --- 1Hz oluşturma 
  always @(posedge clk) begin
    if ((divCounter == 25'd26999999))
      divCounter <= 0;
    else
      divCounter <= divCounter + 1;
  end

endmodule
