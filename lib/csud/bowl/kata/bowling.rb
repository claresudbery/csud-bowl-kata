class Bowling

    ALL_PINS = 10
    STRIKE = "X"
    SPARE = "/"

    def score(rolls)
        frames = rolls.split(" ")
        score = 0

        for index in 0...10
            frame_pin_sum = sum_frame_pins(frames[index])
            strike_score = strike_score(frames[index], frames[index+1], frames[index+2])
            spare_score = spare_score(frames[index], frames[index+1])

            score = score + strike_score + spare_score + frame_pin_sum
        end
        
        score
    end

    private

    def strike_score(this_frame, next_frame, frame_after_next)    
        strike_score = 0    

        if is_strike?(this_frame) 
            strike_score = sum_frame_pins(next_frame)
            if is_strike?(next_frame) 
                strike_score = strike_score + roll_score(frame_after_next[0])
            end
        end

        strike_score
    end

    def spare_score(this_frame, next_frame)    
        spare_score = 0    

        if is_spare?(this_frame)  
            spare_score = roll_score(next_frame[0])
        end

        spare_score
    end

    def is_spare?(frame)
        (frame != STRIKE) && (frame[1] == SPARE)
    end

    def is_strike?(frame)
        frame == STRIKE
    end

    def sum_frame_pins(frame)
        is_strike?(frame) || is_spare?(frame) \
            ? ALL_PINS \
            : roll_score(frame[0]) + roll_score(frame[1])
    end

    def roll_score(roll)
        is_strike?(roll) \
            ? ALL_PINS \
            : roll.to_i
    end

end