#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  option = parse_option
  count_hash = build_count_hash
  result_array = build_result_array(count_hash, option)
  display_total(result_array, option) if count_hash.size > 1
end

def parse_option
  option = ARGV.getopts('l', 'w', 'c')
  no_option = { 'l' => true, 'w' => true, 'c' => true }
  option.value?(true) ? option : no_option
end

def build_count_hash
  if ARGV.size.zero?
    content = $stdin.read
    { '' => content }
  else
    contents = ARGV.map { |file_name| File.read(file_name) }
    ARGV.zip(contents).to_h
  end
end

def build_result_array(count_hash, option)
  result_array = []
  count_hash.each do |file_name, file_content|
    result_hash = {}
    result_hash[:line] = count_line(file_content) if option['l']
    result_hash[:word] = count_word(file_content) if option['w']
    result_hash[:byte] = count_byte(file_content) if option['c']
    result_hash[:file] = " #{file_name}\n"
    result_hash.each_value { |value| print value.to_s.rjust(8) }
    if count_hash.size > 1
      result_hash.delete(:file)
      result_array << result_hash
    end
  end
  result_array
end

def display_total(result_array, option)
  total_array = []
  total_array << result_array.inject(0) { |sum, hash| sum + hash[:line] } if option['l']
  total_array << result_array.inject(0) { |sum, hash| sum + hash[:word] } if option['w']
  total_array << result_array.inject(0) { |sum, hash| sum + hash[:byte] } if option['c']
  total_array.each { |total_number| print total_number.to_s.rjust(8) }
  print ' total'
end

def count_line(file_content)
  file_content.split("\n").size
end

def count_word(file_content)
  file_content.split(nil).size
end

def count_byte(file_content)
  file_content.bytesize
end

main
