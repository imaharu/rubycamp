require_relative 'board'
require 'singleton'

class LengSensor
    include Singleton
    extend Board

    LEFT_PIN = 1
    RIGHT_PIN = 3

    attr_reader :key_process, :raw_value

    def initialize
        @raw_value = []
        @key_process = []
    end

    def update(pin)
        @raw_value[pin] = Board.board.analog_read(pin)
        if on?(pin)
            @key_process[pin] ||= 0
            @key_process[pin] += 1
        else
            @key_process[pin] = 0
        end
    end

    # 押した瞬間だけ判定する
    def down?(pin)
        @key_process[pin] ||= 0
        @key_process[pin] == 1
    end

    # true,falseでのみ返す
    def on?(pin)
        @raw_value[pin] ||= 0
        @raw_value[pin] >= 150
    end
end