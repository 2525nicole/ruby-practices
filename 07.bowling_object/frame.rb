# frozen_string_literal: true

class Frame
  attr_reader :first_shot, :second_shot

  def initialize(first_mark, second_mark, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def calc_scores(frame_number, frames)
    if frame_number <= 9 && calc_regular_scores == 10
      strike = first_shot.score == 10
      double = strike && frames[frame_number].first_shot.score == 10
      spare = !strike && calc_regular_scores == 10
      calc_bonus_scores(strike, double, spare, frame_number, frames)
    else
      calc_regular_scores
    end
  end

  def calc_bonus_scores(strike, double, spare, frame_number, frames)
    next_frame = frames[frame_number]
    after_next_frame = frames[frame_number + 1]
    if double
      10 + next_frame.first_shot.score + (after_next_frame.nil? ? next_frame.second_shot.score : after_next_frame.first_shot.score)
    elsif strike
      10 + next_frame.first_shot.score + next_frame.second_shot.score
    elsif spare
      10 + next_frame.first_shot.score
    end
  end

  def calc_regular_scores
    [@first_shot, @second_shot, @third_shot].map(&:score).sum
  end
end
