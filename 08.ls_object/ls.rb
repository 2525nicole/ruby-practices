# frozen_string_literal: true

require 'optparse'
require_relative './file_list'
require_relative './file_detail'
require_relative './displayed_file_information'

options = ARGV.getopts('a', 'r', 'l')
file_list = FileList.new(a_option: options['a'], r_option: options['r'])
file_names = file_list.file_names_list
file_details = file_list.file_details_list

return if file_names.empty?

displayed_file_information = DisplayedFileInformation.new(file_names:, file_details:) # ここの変数名を修正する
if options['l']
  displayed_file_information.display_details
else
  displayed_file_information.display_file_names
end
