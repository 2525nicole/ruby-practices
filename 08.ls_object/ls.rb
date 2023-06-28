# frozen_string_literal: true

require 'optparse'
require_relative './file_list'
require_relative './ls_execution_result'
require_relative './file_details'

options = ARGV.getopts('a', 'r', 'l')
ls_execution_result = LsExecutionResult.new(options)
ls_execution_result.display(options)
