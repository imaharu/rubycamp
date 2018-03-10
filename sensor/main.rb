require 'dxruby'
require 'smalrubot'

Window.caption = "RubyCamp Example"

Window.width   = 800
Window.height  = 600

board = Smalrubot::Board.new(Smalrubot::TxRx::Serial.new)
font = Font.new(32)

count = 0
sensor = 0

Window.loop do
  
  sensor = board.analog_read(1) # 左側のセンサー
  p 'OK' if sensor > 150
  Window.draw_font(100, 100, sensor.to_s, font)
  count += 1

end