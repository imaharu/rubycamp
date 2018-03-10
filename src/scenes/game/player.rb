class Player
    attr_accessor :x, :y
    
    def initialize(x = 300, y = 300)
        @image = Image.load('images/player.png')
        @image.set_color_key(C_BLACK)
        @x = x
        @y = y
    end
    
    def draw
        Window.draw(@x, @y, @image)

        @x = 0 - @image.width if @x > Window.width
        @x = 799 if @x < 0 - @image.width
        @y = 0 - @image.height if @y > 600
        @y = 600 if @y < 0 - @image.height
    end
end
		    
