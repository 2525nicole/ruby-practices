# frozen_string_literal: true

require 'optparse'
require_relative './file_list'
require_relative './file_display'
require_relative './file_detail'

options= ARGV.getopts('a', 'r', 'l')
file_list = FileList.new(options)
file_names = file_list.file_names_list

return if file_names.empty?

if options['l']
  file_details = file_list.file_details_list
  details_and_options = { displayed_file_information: file_details, options: options }
  displayed_details_list = FileDisplay.new(details_and_options)
  displayed_details_list.display_details
else
  names_and_options = { displayed_file_information: file_names, options: options }
  display_names_list = FileDisplay.new(names_and_options)
  display_names_list.display_file_names
end
