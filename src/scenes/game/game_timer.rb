class GameTimer
    def initialize
        reset
    end

    def start(how_many: 60)
        return false if !@start_time.nil?

        @start_time = Time.now
        @how_many = how_many
        return true
    end

    def update
        return false if @start_time.nil?

        if now_time_diff >= @how_many
            stop
        end
        return true
    end

    def stop
        return false if @start_time.nil?

        @stop_time = Time.now
        return true
    end

    def stop?
        !@stop_time.nil?
    end

    def now_time_diff
        return false if @start_time.nil?

        Time.now - @start_time
    end

    def end_time_diff
        return false if @start_time.nil?

        @stop_time - @start_time
    end

    def remaining_time
        return how_many if @start_time.nil?

        diff = @how_many - now_time_diff
        return 0 if diff < 0
        diff
    end

    def reset
        @start_time = nil
        @stop_time = nil
        @how_many = 60
    end
end