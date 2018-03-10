class Rool
  
    def initialize
        @font = Font.new(40, 'MS Pゴシック')
        @button_sensor = ButtonSensor.instance
        @leng_sensor = LengSensor.instance
        @image = Image.load("#{$ROOT_PATH}/images/credit.jpg")
        @y = 0
        @dy = 3
    end

    def draw
        Window.draw(0, 0, @image)
        Window.draw_font(320, @y + 600, "クレジット", @font)
        Window.draw_font(50, @y + 700, "  プログラマ  　 中村翔    越智亮太", @font)
        Window.draw_font(50, @y + 800, "ハードウェア　 武本和久 　柳原直樹", @font)
        Window.draw_font(320, @y + 900, "講師の方々", @font)
        Window.draw_font(50, @y + 1000, "野坂 秀和さん   雲嶋 健太さん", @font)
        Window.draw_font(50, @y + 1100, "野口 拓弥さん   五十嵐 邦明さん", @font)
        Window.draw_font(320, @y + 1200, "効果音提供", @font)
        Window.draw_font(320, @y + 1300, "魔王魂", @font)
    end

    def update
        @y -= @dy
    end   
end

