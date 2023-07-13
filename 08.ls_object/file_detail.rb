# frozen_string_literal: true

class FileDetail
  require 'etc'

  attr_reader :file_name

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

  def initialize(file_name:)
    @file_name = file_name
    @file_stat = File.lstat(file_name)
  end

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
    @file_stat.mtime
  end

  def obtain_file_name_and_symlink
    FileTest.symlink?(@file_name) ? "#{@file_name} -> #{File.readlink(@file_name)}" : @file_name
  end

  def obtain_block_number
    @file_stat.blocks
  end
end
