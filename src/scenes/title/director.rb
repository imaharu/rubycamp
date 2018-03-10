require_relative '../../config'
require_relative '../../sensors/button_sensor'
require_relative '../../sensors/leng_sensor'

module Title
    class Director
        def initialize()
            @font = Font.new(32, 'MS Pゴシック')
            @button_sensor = ButtonSensor.instance
            @leng_sensor = LengSensor.instance
            @image = Image.load("#{$ROOT_PATH}/images/title.png")
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
                SceneMgr.move_to(:game)
            elsif @leng_sensor.down?(LengSensor::RIGHT_PIN) ||
                  @leng_sensor.down?(LengSensor::LEFT_PIN)
                SceneMgr.move_to(:game)
            elsif !$DEBUG && @button_sensor.down?(ButtonSensor::RIGHT_PIN) # 運営操作用のマスターkey
                SceneMgr.move_to(:game)
            end
        end

        def draw
            Window.draw(0, 0, @backimg)
            Window.draw(230, 160, @image)
        end
    end
end
