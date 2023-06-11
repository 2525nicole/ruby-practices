# frozen_string_literal: true

class Game
  def initialize(entered_marks)
    @frames = []
    digits_aligned_marks = align_mark_digits(entered_marks)
    create_frames(digits_aligned_marks)
  end

  def align_mark_digits(entered_marks)
    @marks = []
    entered_marks.split(',').each do |m|
      if m == 'X'
        @marks << m
        @marks << 0
      else
        @marks << m
      end
    end
    @marks
  end

  def create_frames(marks)
    marks[0..17].each_slice(2) { |m| @frames << Frame.new(m[0], m[1]) }
    last_frame = marks[18..@marks.length]
    last_frame.delete(0)
    @frames << Frame.new(last_frame[0], last_frame[1], last_frame[2])
  end

  def calc_scores
    num = 0
    total = 0
    @frames.each do |frame|
      total +=
        if num <= 8 && frame.calc_frame_scores == 10
          strike = frame.first_shot.score == 10
          double = strike && @frames[num + 1].first_shot.score == 10
          spare = !strike && frame.calc_frame_scores == 10
          calc_bonus_score(strike, double, spare, num)
        else
          frame.calc_frame_scores
        end
      num += 1
    end
    puts total
  end

  def calc_bonus_score(strike, double, spare, num)
    if double
      10 + @frames[num + 1].first_shot.score + (@frames[num + 2].nil? ? @frames[num + 1].second_shot.score : @frames[num + 2].first_shot.score)
    elsif strike
      10 + @frames[num + 1].first_shot.score + @frames[num + 1].second_shot.score
    elsif spare
      10 + @frames[num + 1].first_shot.score
    end
  end
end
