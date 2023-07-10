# frozen_string_literal: true

require 'optparse'
require_relative './file_list'
require_relative './file_display'
require_relative './file_detail'

options = ARGV.getopts('a', 'r', 'l')
file_list = FileList.new(a_option: options['a'], r_option: options['r'])
file_names = file_list.file_names_list

return if file_names.empty?

file_details = file_list.file_details_list # lオプション有無の条件分岐から外す

# if options['l']
#   displayed_details_list = FileDisplay.new(displayed_file_information: file_details, options: options)
#   displayed_details_list.display_details
# else
#   display_names_list = FileDisplay.new(displayed_file_information: file_names, options: options)
#   display_names_list.display_file_names
# end

displayed_details_list = FileDisplay.new(file_names:, file_details:)
if options['l']
  displayed_details_list.display_details
else
  displayed_details_list.display_file_names
end
