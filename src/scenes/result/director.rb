require_relative '../../sensors/button_sensor'
require_relative '../../sensors/leng_sensor'
require_relative '../game/matz'
require_relative '../../config'

module Result
    
    class Director
        def initialize()
            @font = Font.new(32, 'MS Pゴシック')
            @button_sensor = ButtonSensor.instance
            @leng_sensor = LengSensor.instance
            @big_matz = Image.load("#{$ROOT_PATH}/images/result_big_matz.png")
            @backimg = Image.load("#{$ROOT_PATH}/images/backgrand.bmp")
        end

        def play
            draw
            if $DEBUG
                @button_sensor.update(ButtonSensor::LEFT_PIN); @button_sensor.update(ButtonSensor::RIGHT_PIN)
            else
                @button_sensor.update(ButtonSensor::RIGHT_PIN) # 運営操作用のマスターkey
            end
            
            @leng_sensor.update(LengSensor::LEFT_PIN); @leng_sensor.update(LengSensor::RIGHT_PIN)
            update
        end

        private

        def update
            if $DEBUG && (@button_sensor.down?(ButtonSensor::LEFT_PIN) || 
                          @button_sensor.down?(ButtonSensor::RIGHT_PIN))
                SceneMgr.move_to(:credit)
            elsif @leng_sensor.down?(LengSensor::RIGHT_PIN) ||
                  @leng_sensor.down?(LengSensor::LEFT_PIN)
                SceneMgr.move_to(:credit)
            elsif !$DEBUG && @button_sensor.down?(ButtonSensor::RIGHT_PIN) # 運営操作用のマスターkey
                SceneMgr.move_to(:credit)
            end
        end

        def draw
            Window.draw(0, 0, @backimg)
            Window.draw_font(350, 50, "結果画面", @font, color: [0,0,0])
            Window.draw(25, 100, @big_matz)
            Window.draw_font(550, 250, "恋の行方: #{Matz.favorability_status}", @font, color: [0,0,0])
            Window.draw_font(550, 400, "好感度: #{Matz.favorability_rate}", @font, color: [0,0,0])
        end
    end

end
