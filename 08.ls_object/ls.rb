# frozen_string_literal: true

require 'optparse'
require_relative './file_list'
require_relative './file_detail'
require_relative './displayed_file_formatter'

options = ARGV.getopts('a', 'r', 'l')
file_list = FileList.new(a_option: options['a'], r_option: options['r'])
file_details = file_list.file_details

return if file_details.all? { |file| file.file_name.empty? }

fromatted_files = DisplayedFileFormatter.new(file_details:)
if options['l']
  fromatted_files.display_details
else
  fromatted_files.display_file_names
end
