# frozen_string_literal: true

require 'optparse'
require_relative './file_list'
require_relative './file_detail'
require_relative './displayed_file_formatter'

options = ARGV.getopts('a', 'r', 'l')
file_list = FileList.new(a_option: options['a'], r_option: options['r'])

return if file_list.file_details.empty?

displayed_files = DisplayedFileFormatter.new(file_list:, l_option: options['l'])
displayed_files.display_formatted_files
