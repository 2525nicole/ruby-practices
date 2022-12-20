#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  option = parse_option
  contents_by_file_name = build_contents_by_file_name
  count_data_list = build_count_data_list(contents_by_file_name, option)
  total_numbers = build_total_numbers(count_data_list, option) if contents_by_file_name.size > 1
  build_display_format(count_data_list, total_numbers)
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

def build_count_data_list(contents_by_file_name, option)
  count_data_list = []
  contents_by_file_name.each do |file_name, file_content|
    result_hash = {}
    result_hash[:line] = count_line(file_content) if option['l']
    result_hash[:word] = count_word(file_content) if option['w']
    result_hash[:byte] = count_byte(file_content) if option['c']
    result_hash[:file] = file_name
    count_data_list << result_hash
  end
  count_data_list
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

def build_total_numbers(count_data_list, option)
  total_hash = {}
  total_hash[:line] = count_data_list.sum { |hash| hash[:line] } if option['l']
  total_hash[:word] = count_data_list.sum { |hash| hash[:word] } if option['w']
  total_hash[:byte] = count_data_list.sum { |hash| hash[:byte] } if option['c']
  total_hash
end

def build_display_format(count_data_list, total_numbers)
  count_data_list_with_file_name = count_data_list.each { |hash| hash[:file] = "#{hash[:file]}\n" }
  count_data_list_with_file_name.each { |result| display_specified_contents(result.values) }
  return unless total_numbers

  display_specified_contents(total_numbers.values)
  print ' total'
end

def display_specified_contents(specified_contents)
  specified_contents.each { |content| print " #{content}".rjust(8) }
end

main
