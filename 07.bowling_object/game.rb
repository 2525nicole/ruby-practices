# frozen_string_literal: true

class Game
  def initialize(entered_marks)
    @frames = []
    digits_aligned_marks = align_digits(entered_marks)
    create_frames(digits_aligned_marks)
  end

  def align_digits(entered_marks)
    marks = []
    entered_marks.split(',').each do |m|
      if m == 'X'
        marks << m
        marks << 0
      else
        marks << m
      end
    end
    marks
  end

  def create_frames(marks)
    marks[0..17].each_slice(2) { |m| @frames << Frame.new(m[0], m[1]) }
    last_frame = marks[18..marks.length]
    last_frame.delete(0)
    @frames << Frame.new(last_frame[0], last_frame[1], last_frame[2])
  end

  def show_score
    total =
      @frames.each.with_index(1).sum do |frame, frame_number|
        frame.calc_scores(frame_number, @frames)
      end
    puts total
  end
end
