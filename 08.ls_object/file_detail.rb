# frozen_string_literal: true

class FileDetail
  require 'etc'

  # attr_reader :file_detail

  # def initialize(args)
  #   @file_name = args[:file_name]
  #   @file_stat = args[:file_stat]
  #   @file_detail = build_file_detail
  # end

  def initialize(file_name:)
    @file_name = file_name
    @file_stat = File.lstat(file_name)
  end

  # private

  FILETYPES_LIST = {
    'file' => '-',
    'directory' => 'd',
    'link' => 'l'
  }.freeze

  PERMISSION_LIST = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-WX',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  # def build_file_detail
  #   { permission: obtain_permission,
  #     hardlink_number: obtain_hardlink_number,
  #     owner: obtain_owner,
  #     group: obtain_group,
  #     filesize: obtain_filesize,
  #     time_stamp: obtain_time_stamp,
  #     name_and_symlink: obtain_file_name_and_symlink,
  #     block_number: obtain_block_number }
  # end

  def obtain_permission
    [FILETYPES_LIST[@file_stat.ftype], @file_stat.mode.to_s(8).slice(-3..-1).chars.map { |char| PERMISSION_LIST[char] }].join
  end

  def obtain_hardlink_number
    @file_stat.nlink.to_s
  end

  def obtain_owner
    Etc.getpwuid(@file_stat.uid).name
  end

  def obtain_group
    Etc.getgrgid(@file_stat.gid).name.to_s
  end

  def obtain_filesize
    @file_stat.size.to_s
  end

  def obtain_time_stamp
    # @file_stat.mtime.strftime('%_m %_d %R')
    @file_stat.mtime#.strftime('%_m %_d %R')
  end

  def obtain_file_name_and_symlink
    FileTest.symlink?(@file_name) ? "#{@file_name} -> #{File.readlink(@file_name)}" : @file_name
  end

  def obtain_block_number
    @file_stat.blocks
  end
end
