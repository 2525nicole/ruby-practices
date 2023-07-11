# frozen_string_literal: true

class FileList
  attr_reader :file_names_list, :file_details_list

  def initialize(a_option:, r_option:)
    @a_option = a_option
    @r_option = r_option
    @file_names_list = build_file_names_list
    @file_details_list = build_file_details_list
  end

  private

  def build_file_names_list
    file_names = Dir.glob('*', @a_option ? File::FNM_DOTMATCH : 0).sort
    @r_option ? file_names.reverse : file_names
  end

  def build_file_details_list
    file_details = []
    @file_names_list.each do |file_name|
      file_detail = FileDetail.new(file_name:)
      file_detail_hash = {
        permission: file_detail.obtain_permission,
        hardlink_number: file_detail.obtain_hardlink_number,
        owner: file_detail.obtain_owner,
        group: file_detail.obtain_group,
        filesize: file_detail.obtain_filesize,
        time_stamp: file_detail.obtain_time_stamp,
        name_and_symlink: file_detail.obtain_file_name_and_symlink,
        block_number: file_detail.obtain_block_number
      }
      file_details << file_detail_hash
    end
    file_details
  end
end
