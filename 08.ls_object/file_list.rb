# frozen_string_literal: true

class FileList
  attr_reader :file_names_list, :file_details_list

  def initialize(options)
    @options = options
    @file_names_list = build_file_names_list
    @file_details_list = build_file_details_list
  end

  private

  def build_file_names_list
    file_names = Dir.glob('*', @options['a'] ? File::FNM_DOTMATCH : 0).sort
    @options['r'] ? file_names.reverse : file_names
  end

  def build_file_details_list
    file_details_array = []
    @file_names_list.each do |file_name|
      args = { file_name:, file_stat: File.lstat(file_name) }
      file_detail_hash = FileDetail.new(args).file_detail
      file_details_array << file_detail_hash
    end
    file_details_array
  end
end
