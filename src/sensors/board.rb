require 'smalrubot'

module Board
    @@board = Smalrubot::Board.new(Smalrubot::TxRx::Serial.new)

    def self.board
        @@board
    end
end
