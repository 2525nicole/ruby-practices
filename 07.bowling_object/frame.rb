# frozen_string_literal: true

class Frame
  attr_reader :first_shot, :second_shot

  def initialize(first_mark, second_mark, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def calc_scores(index, frames)
    if index <= 8 && calc_regular_scores == 10
      strike = first_shot.score == 10
      double = strike && frames[index + 1].first_shot.score == 10
      spare = !strike && calc_regular_scores == 10
      calc_bonus_scores(strike, double, spare, index, frames)
    else
      calc_regular_scores
    end
  end

  def calc_bonus_scores(strike, double, spare, index, frames)
    if double
      10 + frames[index + 1].first_shot.score + (frames[index + 2].nil? ? frames[index + 1].second_shot.score : frames[index + 2].first_shot.score)
    elsif strike
      10 + frames[index + 1].first_shot.score + frames[index + 1].second_shot.score
    elsif spare
      10 + frames[index + 1].first_shot.score
    end
  end

  def calc_regular_scores
    [@first_shot, @second_shot, @third_shot].map(&:score).sum
  end
end
