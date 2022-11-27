#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

OPTIONS = ARGV.getopts('l', 'w', 'c')
NO_OPTION = OPTIONS == { 'l' => false, 'w' => false, 'c' => false }
NO_OR_L = NO_OPTION || OPTIONS['l']
NO_OR_W = NO_OPTION || OPTIONS['w']
NO_OR_C = NO_OPTION || OPTIONS['c']
ARGV_SIZE = ARGV.size
ARGV_ELEMENTS = ARGV[0..ARGV_SIZE]

def main
  ARGV_SIZE.zero? ? standard_input : argument
end

def argument_lines
  ARGV_ELEMENTS.map { |file_name| File.open(file_name).read.count("\n").to_s } if NO_OR_L
end

def argument_words
  ARGV_ELEMENTS.map { |file_name| File.open(file_name).read.to_s.split(nil).size.to_s } if NO_OR_W
end

def argument_bytes
  ARGV_ELEMENTS.map { |file_name| File.open(file_name).read.to_s.bytesize.to_s } if NO_OR_C
end

def argument
  results = [argument_lines, argument_words, argument_bytes].compact

  argument_results = results.map { |ar| ar.map { |arm| arm.to_s.rjust(8) } }
  argument_results << ARGV.map { |am| " #{am.ljust(ARGV_SIZE)}" }
  argument_results.transpose.map { |art| puts art.join('') }

  puts "#{results.map { |ft| ft.map(&:to_i).sum.to_s.rjust(8) }.join('')} total" if ARGV_SIZE > 1
end

def standard_input
  input = $stdin.readlines

  input_lines = input.size if NO_OR_L

  input_words = input.join('').split(' ' || "\n").size.to_s if NO_OR_W

  input_bytes = input.join('').bytesize.to_s if NO_OR_C

  [input_lines, input_words, input_bytes].compact.map { |tr| print tr.to_s.rjust(8) }
end

main
