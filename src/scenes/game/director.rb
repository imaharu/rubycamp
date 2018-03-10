require_relative '../../config'
require_relative '../../sensors/button_sensor'
require_relative '../../sensors/leng_sensor'
require_relative 'player'

require_relative 'item'
require_relative 'items/ruby'
require_relative 'items/python'
require_relative 'items/castle'
require_relative 'items/bomb'
require_relative 'items/cookie'

require_relative 'matz'
require_relative 'game_timer'
require_relative 'love_gage'
require 'smalrubot'


def update_time(time_frame)
    time_frame += 1
end

def update_image(x, image_random_seed)
    case image_random_seed
    when (0..30) then
        ::Ruby.new(x, 0, "#{$ROOT_PATH}/images/ruby_notes.png")
    when (30..60) then
        ::Castle.new(x, 0, "#{$ROOT_PATH}/images/castle_notes.jpg")
    when (60..80) then
        ::Python.new(x, 0, "#{$ROOT_PATH}/images/python_notes.png")
    when (80..90) then
        ::Bomb.new(x, 0, "#{$ROOT_PATH}/images/bomb_notes.png")
    when (90..100) then
        ::Cookie.new(x, 0, "#{$ROOT_PATH}/images/cookie_notes.png")
    end
end

def check_add_point(item_center, height)
    450- (height / 2) <= item_center && item_center <= 600 - (height / 2)
end

def add_effect(present)
    tmp_image = 
        case present
        when :ruby
            @love
        when :castle
            @love
        when :python
            @trouble
        when :bomb
            @trouble
        when :cookie
            @anger
        end
    Window.draw(120, 0, tmp_image)
end

module Game
    class Director
        def initialize
            @button_sensor = ButtonSensor.instance
            @leng_sensor = LengSensor.instance

            # 描画関係
            @bg = Image.load("#{$ROOT_PATH}/images/background.jpg")
            @items_right = [::Ruby.new(401, -100, "#{$ROOT_PATH}/images/ruby_notes.png")]
            @items_left = [::Cookie.new(299, -100, "#{$ROOT_PATH}/images/cookie_notes.png")]
            @lane_right = Image.new(100, 600, [200, 252, 190, 193]).box_fill(0, 450, 100, 600, [150, 249, 130, 137])
            @lane_center =  Image.new(2, 600, [255, 255, 255])
            @lane_left = Image.new(100, 600, [200, 252, 190, 193]).box_fill(0, 450, 100, 600, [150, 249, 130, 137])
            @love = Image.load("#{$ROOT_PATH}/images/love.png").set_color_key(C_WHITE)
            @trouble = Image.load("#{$ROOT_PATH}/images/trouble.png").set_color_key(C_WHITE)
            @anger = Image.load("#{$ROOT_PATH}/images/anger.png").set_color_key(C_WHITE)
            @frm = 1
            @dx = 0
            @dy = 1
            @time_frame = 0

            # 変数 得点時のeffectのため
            @Rcount_for_effect = 0
            @Rflag_effect = false
            @Lcount_for_effect = 0
            @Lflag_effect = false

            @image_random_seed = Random.new
            @matz = Matz.new()
            @timer = GameTimer.new()
            @font = Font.new(32, 'MS Pゴシック')

            @love_gage = LoveGage.new(@matz)
        end

        def play
            if $DEBUG
                @timer.start(how_many: 30)
            else
                @timer.start(how_many: 60)
            end
            draw
            if $DEBUG
                @button_sensor.update(ButtonSensor::LEFT_PIN); @button_sensor.update(ButtonSensor::RIGHT_PIN)
            else
                @button_sensor.update(ButtonSensor::RIGHT_PIN) # 運営操作用のマスターkey
            end
            @leng_sensor.update(LengSensor::LEFT_PIN); @leng_sensor.update(LengSensor::RIGHT_PIN)

            update_all_items(@items_right)
            update_all_items(@items_left)
            @matz.update_all_presents
            update
            @timer.update
        end

        private
        # itemsを一括でupdateする
        def update_all_items(items = [])
            items.each do |item|
                item.update
            end
        end

        def update
            @dx = 10 if @frm == 30 # @dxにセンサー等の値を入れる
            @frm += 1
            @frm = 0 if @frm > 30

            if @Rflag_effect
                if @Rcount_for_effect != 20
                    check_all_items_for_effect(@items_right)
                    @Rcount_for_effect += 1
                else
                    @Rcount_for_effect = 0
                    @Rflag_effect = false
                end
            end

            if @Lflag_effect
                if @Lcount_for_effect != 20
                    check_all_items_for_effect(@items_left)
                    @Lcount_for_effect += 1
                else
                    @Lcount_for_effect = 0
                    @Lflag_effect = false
                end
            end

            @time_frame = update_time(@time_frame)

            # 画像の追加
            if @time_frame % 100 == 0
                @items_left << update_image(299, @image_random_seed.rand(100))
                @items_right << update_image(401, @image_random_seed.rand(100))
            end

            # 下まで来たときに配列削除
            delete_item_from_outside_screen(@items_right)
            delete_item_from_outside_screen(@items_left)
            @matz.delete_present_from_outside_screen

            if @timer.stop?
                SceneMgr.move_to(:result)
                @timer.reset
            elsif !$DEBUG && @button_sensor.down?(ButtonSensor::RIGHT_PIN) # 運営操作用のマスターkey
                SceneMgr.move_to(:result)
            end

            if $DEBUG && @button_sensor.down?(ButtonSensor::RIGHT_PIN) ||
               @leng_sensor.down?(LengSensor::RIGHT_PIN)
                check_all_items(@items_right)
                @Rflag_effect = true
            end

            if $DEBUG && @button_sensor.down?(ButtonSensor::LEFT_PIN) ||
               @leng_sensor.down?(LengSensor::LEFT_PIN)
                check_all_items(@items_left)
                @Lflag_effect = true
            end
        end

        # item配列を一括で判定があるかチェックする
        def check_all_items(items = [])
            items.each do |item|
                if check_add_point(item.y, item.height)
                    @matz.receive_present(item)
                end
            end
        end

        def check_all_items_for_effect(items = [])
            items.each do |item|
                if check_add_point(item.y, item.height)
                    add_effect(item.class.status)
                end
            end
        end

        def delete_item_from_outside_screen(items = [], outline: 600)
            items.each do |item|
                if item.y > outline
                    items.delete_at(0)
                end
            end
        end


        def draw
            Window.draw(0, 0, @bg)
            
            @love_gage.draw
            @matz.draw

            Window.draw(299, 0, @lane_left)
            Window.draw(399, 0, @lane_center)
            Window.draw(401, 0, @lane_right)

            draw_all_items(@items_right)
            draw_all_items(@items_left)
            draw_all_items(@matz.get_presents)

            Window.draw_font(630, 30, "Time: #{@timer.remaining_time.round(2)}", @font, color: [0,0,0])
        end

        def draw_all_items(items)
            items.each do |item|
                item.draw
            end
        end
    end
end
