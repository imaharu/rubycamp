class Item
    attr_reader :x, :y, :height
    @status = nil

    def self.status
        @status
    end


    def initialize(x = 0, y = 300, image)
        @image = Image.load(image)
        @height = @image.height
        @x = x
        @y = y
        @dy = 3
    end

    def draw
        Window.draw(@x, @y, @image)
    end

    def update(dx: 0, dy: @dy)
        @x += dx
        @y += dy
    end
end
