# frozen_string_literal: true

class FileList
  attr_reader :file_details, :total_blocks

  def initialize(a_option:, r_option:)
    @a_option = a_option
    @r_option = r_option
    @file_details = build_file_details
    @total_blocks = calc_total_blocks
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

  def calc_total_blocks
    @file_details.map(&:block_number).sum
  end
end
