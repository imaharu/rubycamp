require_relative '../../config'
require_relative '../../sound_mgr'

class Matz
    @@favorability_rate = 20 # 好感度
    @@favorability_status = 'normal' # 好感度段階
    @@font = Font.new(32, 'MS Pゴシック')
    @@rate_x = 720
    @@rate_y = 400

    def self.favorability_rate
        @@favorability_rate
    end

    def self.favorability_status
        @@favorability_status
    end


    def initialize
        @big_matz = Image.load("#{$ROOT_PATH}/images/big_matz.png")
        @small_matz = Image.load("#{$ROOT_PATH}/images/small_matz.jpeg")
        @presents = []
        @present_dx = 60
        @present_dy = 0
    end

    def draw
        Window.draw(-450, 75, @big_matz)
        Window.draw(700, 500, @small_matz)
        Window.draw_font(710, 300, "#{@@favorability_status}", @@font)
        Window.draw_font(@@rate_x, @@rate_y, "#{@@favorability_rate}", @@font)
    end

    def receive_present(present)
        @@favorability_rate +=
            case present.class.status
            when :ruby
                SoundMgr.ruby_sound_play
                20
            when :castle
                SoundMgr.castle_sound_play
                10
            when :python
                SoundMgr.python_sound_play
                -10
            when :bomb
                SoundMgr.bomb_sound_play
                -20
            when :cookie
                SoundMgr.cookie_sound_play
                -30
            end
        @present_dy = (@@rate_y - present.y) / ((@@rate_x - present.x) / @present_dx) # 移動距離を計算します。
        @presents.push(present.dup)
        update_status
    end

    def get_presents
      @presents
    end

    def update_all_presents
      @presents.each do |present|
        present.update(dx: @present_dx, dy: @present_dy)
      end
    end

    def delete_present_from_outside_screen(outline: @@rate_x)
      if @presents[0] != nil
        if @presents[0].x > outline
          @presents.delete_at(0)
        end
      end
    end

    private

    # @favorability_rateを元に、statusを変更する
    # @favorability_rateが変更された後に呼び出す
    def update_status
        @@favorability_status =
            if @@favorability_rate <= 0
                '激怒'
            elsif @@favorability_rate < 20
                '他人'
            elsif @@favorability_rate < 40
                'ランチ'
            elsif @@favorability_rate < 60
                '交際'
            elsif @@favorability_rate < 80
                '同棲'
            else
                '結婚'
            end

    end

end
