#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  option = parse_option
  contents_by_file_name = build_contents_by_file_name
  count_data_list = build_count_data_list(contents_by_file_name)
  count_data_list << build_total_numbers(count_data_list) if count_data_list.size > 1
  display_results(count_data_list, option)
end

def parse_option
  option = ARGV.getopts('l', 'w', 'c')
  no_option = { 'l' => true, 'w' => true, 'c' => true }
  option.value?(true) ? option : no_option
end

def build_contents_by_file_name
  if ARGV.size.zero?
    content = $stdin.read
    { '' => content }
  else
    contents = ARGV.map { |file_name| File.read(file_name) }
    ARGV.zip(contents).to_h
  end
end

def build_count_data_list(contents_by_file_name)
  contents_by_file_name.map do |file_name, file_content|
    {
      line: count_line(file_content),
      word: count_word(file_content),
      byte: count_byte(file_content),
      file: file_name
    }
  end
end

def count_line(file_content)
  file_content.split("\n").size
end

def count_word(file_content)
  file_content.split(' ').size
end

def count_byte(file_content)
  file_content.bytesize
end

def build_total_numbers(count_data_list)
  {
    line: count_data_list.sum { |hash| hash[:line] },
    word: count_data_list.sum { |hash| hash[:word] },
    byte: count_data_list.sum { |hash| hash[:byte] },
    file: 'total'
  }
end

def display_results(count_data_list, option)
  count_data_list.each do |result|
    result_to_display = result.map { |key, val| [key, judge_value(key, val)] }.to_h
    print result_to_display[:line] if option['l']
    print result_to_display[:word] if option['w']
    print result_to_display[:byte] if option['c']
    puts " #{result_to_display[:file]}"
  end
end

def judge_value(key, value)
  key == :file ? value : value.to_s.rjust(8)
end

main
