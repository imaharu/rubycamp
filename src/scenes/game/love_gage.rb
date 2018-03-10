class LoveGage
    def initialize(matz_obj)
        @matz = matz_obj
        @gage_box = Image.new(200, 350).box(0, 0, 200, 400, [255, 255, 255])
        @gage_memory = Image.new(90, 30).box_fill(0, 0, 90, 40, [255,20,147])

        @box_sprite = Sprite.new(700, 120, @gage_box)
        @memory_sprites = [Sprite.new(705, 438, @gage_memory)]
        @init_memory_y = @memory_sprites[0].y
        10.times do |i|
            @memory_sprites << Sprite.new(705, @memory_sprites[i].y - 35, @gage_memory)
        end
    end

    def draw
        @box_sprite.draw

        return if Matz.favorability_rate <= 0

        (Matz.favorability_rate > 100 ? 10 : Matz.favorability_rate / 10).times do |i|
            @memory_sprites[i].draw
        end
    end
end