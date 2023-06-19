# frozen_string_literal: true

class Frame
  attr_reader :first_shot, :second_shot

  def initialize(first_mark, second_mark, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def calc_bonus_scores(next_frame, after_next_frame = nil)
    10 +
      if double?(next_frame)
        next_point(next_frame) + (after_next_frame.nil? ? next_frame.second_shot.score : after_next_frame.first_shot.score)
      elsif strike?
        next_point(next_frame) + next_frame.second_shot.score
      else
        next_point(next_frame)
      end
  end

  def strike?
    first_shot.score == 10
  end

  def double?(next_frame)
    strike? && next_frame.first_shot.score == 10
  end

  def next_point(next_frame)
    next_frame.first_shot.score
  end

  def calc_regular_scores
    [@first_shot, @second_shot, @third_shot].map(&:score).sum
  end
end
