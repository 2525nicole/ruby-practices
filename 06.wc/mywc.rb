#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = decision_option
  argv_size = ARGV.size
  count_result = execution(ARGV.size.zero? ? standard_input : filename, options)
  display_results(count_result, argv_size)
end

def decision_option
  option = ARGV.getopts('l', 'w', 'c')
  no_option = { 'l' => true, 'w' => true, 'c' => true }
  option.value?(true) ? option : no_option
end

def standard_input
  $stdin.readlines
end

def filename
  ARGV.map { |file_name| File.open(file_name).read.to_s }
end

def execution(argument, options)
  results = []
  n = 0
  argument.each do |file|
    results << file.split("\n").size if options['l']
    results << file.split(nil).size if options['w']
    results << file.bytesize if options['c']
    results << " #{ARGV[n]}\n"
    n += 1
  end
  results
end

def display_results(count_result, argv_size)
  divisor = argv_size.zero? ? count_result.count(" \n") : argv_size
  total_preparation = count_result.each_slice(count_result.size / divisor).to_a.transpose
  total_preparation.pop
  total_results = total_preparation.map { |t| t.map(&:to_i).sum.to_s.rjust(8) }.join('')
  if argv_size >= 1
    print count_result.map { |r| r.to_s.rjust(8) }.join('')
    print "#{total_results} total"
  else
    print total_results
  end
end

main
