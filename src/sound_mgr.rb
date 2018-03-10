require 'dxruby'
require_relative './config'

class SoundMgr
    @@ruby_sound    = Sound.new("#{$ROOT_PATH}/sound/ruby.wav")
    @@castle_sound  = Sound.new("#{$ROOT_PATH}/sound/castle.wav")
    @@python_sound  = Sound.new("#{$ROOT_PATH}/sound/python.wav")
    @@bomb_sound    = Sound.new("#{$ROOT_PATH}/sound/bomb.wav")
    @@cookie_sound  = Sound.new("#{$ROOT_PATH}/sound/cookie.wav")

    def self.ruby_sound_play
        @@ruby_sound.play
    end

    def self.castle_sound_play
        @@castle_sound.play
    end

    def self.python_sound_play
        @@python_sound.play
    end

    def self.bomb_sound_play
        @@bomb_sound.play
    end

    def self.cookie_sound_play
        @@cookie_sound.play
    end
end
