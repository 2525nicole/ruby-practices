#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  option = decide_option
  argv_size = ARGV.size
  count_target = format_count_target(argv_size)
  display_result(count_target, option)
  display_total(count_target, option) if argv_size > 1
end

def decide_option
  option = ARGV.getopts('l', 'w', 'c')
  no_option = { 'l' => true, 'w' => true, 'c' => true }
  option.value?(true) ? option : no_option
end

def format_count_target(argv_size)
  if argv_size.zero?
    content = $stdin.read
    { '' => content }
  else
    contents = ARGV.map { |file_name| File.open(file_name).read }
    ARGV.zip(contents).to_h
  end
end

def count_line(target_content)
  target_content.split("\n").size
end

def count_word(target_content)
  target_content.split(nil).size
end

def count_byte(target_content)
  target_content.bytesize
end

def display_result(count_target, option)
  count_target.each do |file_name, target_content|
    print count_line(target_content).to_s.rjust(8) if option['l']
    print count_word(target_content).to_s.rjust(8) if option['w']
    print count_byte(target_content).to_s.rjust(8) if option['c']
    print " #{file_name}\n"
  end
end

def display_total(count_target, option)
  line_number = 0
  word_number = 0
  byte_number = 0
  count_target.each_value do |target_content|
    line_number += count_line(target_content)
    word_number += count_word(target_content)
    byte_number += count_byte(target_content)
  end
  line_number_display = line_number.to_s.rjust(8) if option['l']
  word_number_display = word_number.to_s.rjust(8) if option['w']
  byte_number_display = byte_number.to_s.rjust(8) if option['c']
  print "#{line_number_display}#{word_number_display}#{byte_number_display} total"
end

main
