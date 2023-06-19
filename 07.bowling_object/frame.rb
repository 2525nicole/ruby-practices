# frozen_string_literal: true

class Frame
  attr_reader :first_shot, :second_shot

  def initialize(first_mark, second_mark, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def calc_bonus_scores(frame_number, next_frame, after_next_frame = nil)
    strike = first_shot.score == 10
    double = strike && next_frame.first_shot.score == 10
    spare = !strike && calc_regular_scores == 10
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
