# frozen_string_literal: true

class FileDetails
  require 'etc'

  attr_reader :total_blocks, :file_names_list, :file_details

  def initialize(options)
    @options = options
    @file_names_list = FileList.new(@options).file_names_list
    @file_stats = build_file_stats
    @total_blocks = calc_total_blocks
    @file_details = build_file_details
  end

  private

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

  def build_file_stats
    @file_names_list.map { |f| File.lstat(f) }
  end

  def calc_total_blocks
    @file_stats.sum(&:blocks)
  end

  def build_file_details
    { permissions: build_permissions_array,
      hardlinks: build_hardlinks_array,
      owners: build_owners_array,
      groups: build_groups_array,
      filesizes: build_filesizes_array,
      time_stamps: build_time_stamps_array,
      names_and_symlinks: build_file_names_and_symlinks }
  end

  def build_permissions_array
    @file_stats.map do |f|
      [FILETYPES_LIST[f.ftype], f.mode.to_s(8).slice(-3..-1).chars.map { |char| PERMISSION_LIST[char] }].join
    end
  end

  def build_hardlinks_array
    @file_stats.map { |f| f.nlink.to_s }
  end

  def build_owners_array
    @file_stats.map { |f| Etc.getpwuid(f.uid).name }
  end

  def build_groups_array
    @file_stats.map { |f| " #{Etc.getgrgid(f.gid).name}" }
  end

  def build_filesizes_array
    @file_stats.map { |f| f.size.to_s }
  end

  def build_time_stamps_array
    @file_stats.map { |f| f.mtime.strftime('%_m %_d %R') }
  end

  def build_file_names_and_symlinks
    @file_names_list.map { |f| FileTest.symlink?(f) ? "#{f} -> #{File.readlink(f)}" : f }
  end
end
