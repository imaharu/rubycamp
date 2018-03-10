require_relative '../../config'
require_relative '../../sensors/button_sensor'
require_relative '../../sensors/leng_sensor'
require_relative '../../scenes/credit/rool'

module Credit

    class Director
        def initialize
            @rool = Rool.new()
	        @button_sensor = ButtonSensor.instance
            @leng_sensor = LengSensor.instance
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
            @rool.update
        end

        private

        def update
            if $DEBUG && (@button_sensor.down?(ButtonSensor::LEFT_PIN) ||
                          @button_sensor.down?(ButtonSensor::RIGHT_PIN))
                SceneMgr.move_to(:title)
            elsif @leng_sensor.down?(LengSensor::RIGHT_PIN) ||
                  @leng_sensor.down?(LengSensor::LEFT_PIN)
                SceneMgr.move_to(:title)
            elsif !$DEBUG && @button_sensor.down?(ButtonSensor::RIGHT_PIN) # 運営操作用のマスターkey
                SceneMgr.move_to(:title)
            end
        end

        def draw
            @rool.draw
        end
    end

end
