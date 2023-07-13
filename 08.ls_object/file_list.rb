# frozen_string_literal: true

class FileList
  attr_reader :file_details

  def initialize(a_option:, r_option:)
    @a_option = a_option
    @r_option = r_option
    @file_details = build_file_details
  end

  private

  def build_file_details
    file_details = []
    file_names = Dir.glob('*', @a_option ? File::FNM_DOTMATCH : 0).sort
    (@r_option ? file_names.reverse : file_names).each do |file_name|
      file_detail = FileDetail.new(file_name:)
      file_details << file_detail
    end
    file_details
  end
end
