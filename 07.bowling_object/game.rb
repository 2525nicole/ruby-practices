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

  def calc_scores #1
    n = 0
    total = 0
    @frames.each do |frame|
      non_last_frame = n <= 8
      strike = frame.first_shot.score == 10
      double = non_last_frame && strike && @frames[n + 1].first_shot.score == 10
      spare = !strike && frame.calc_frame_scores == 10 #1

      total +=
        if double #1
          10 + @frames[n + 1].first_shot.score + (@frames[n + 2].nil? ? @frames[n + 1].second_shot.score : @frames[n + 2].first_shot.score) #1
        elsif non_last_frame && strike #2
          10 + @frames[n + 1].first_shot.score + @frames[n + 1].second_shot.score
        elsif non_last_frame && spare #2
          10 + @frames[n + 1].first_shot.score
        else #1
          frame.calc_frame_scores
        end
      n += 1
    end
    puts total
  end
end
