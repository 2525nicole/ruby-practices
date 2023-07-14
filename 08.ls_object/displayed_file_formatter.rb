# frozen_string_literal: true

class DisplayedFileFormatter
  def initialize(file_details:, l_option:)
    @file_details = file_details
    @l_option = l_option
  end

  def display_formatted_files
    if @l_option
      display_fromatted_details
    else
      format_file_names.transpose.each { |n| puts n.join(' ') }
    end
  end

  def display_fromatted_details
    puts "total #{calc_total_blocks}"
      @file_details.each do |file_detail|
        file_detail =
          { permission: "#{file_detail.obtain_permission} ",
            hardlink: file_detail.obtain_hardlink_number.rjust(find_max_size(@file_details.map(&:obtain_hardlink_number))),
            owner: "#{file_detail.obtain_owner} ".ljust(find_max_size(@file_details.map(&:obtain_owner))),
            group: "#{file_detail.obtain_group} ".ljust(find_max_size(@file_details.map(&:obtain_group))),
            filesize: file_detail.obtain_filesize.rjust(find_max_size(@file_details.map(&:obtain_filesize))),
            time_stamp: file_detail.obtain_time_stamp.strftime('%_m %_d %R'),
            file_name_and_symlink: File.symlink?(file_detail.file_name) ? format_file_name_and_symlink(file_detail) : file_detail.file_name }
        puts file_detail.values.join(' ')
      end
  end

  private
  
  def calc_total_blocks
    @file_details.map(&:obtain_block_number).sum
  end

  def find_max_size(targets)
    targets.map(&:size).max
  end

  def format_file_name_and_symlink(file_detail)
    "#{file_detail.file_name} -> #{file_detail.obtain_symlink}"
  end

  def format_file_names
    max_columns = 3
    display_width = find_display_width
    columns_number = calc_columns_number(max_columns, display_width)
    columns_width = calc_columns_width(display_width, columns_number)
    rows_number = calc_rows_number(columns_number)

    left_alignment_file_names = @file_details.map(&:file_name).map { |d| d.ljust(columns_width - 1) }
    file_names_per_rows = left_alignment_file_names.each_slice(rows_number).to_a
    file_names_per_rows.map { |element| element.values_at(0...rows_number) }
  end

  def find_display_width
    `tput cols`.to_i
  end

  def calc_columns_number(max_columns, display_width)
    longest_name_size = find_max_size(@file_details.map(&:file_name))
    minus_columns = (0...max_columns).find { longest_name_size < display_width / (max_columns - _1) } || max_columns - 1
    max_columns - minus_columns
  end

  def calc_columns_width(display_width, columns_number)
    display_width / columns_number
  end

  def calc_rows_number(columns_number)
    (@file_details.size / columns_number.to_f).ceil
  end
end
