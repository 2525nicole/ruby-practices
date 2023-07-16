# frozen_string_literal: true

class DisplayedFileFormatter
  def initialize(total_blocks:, file_details:, l_option:)
    @total_blocks = total_blocks
    @file_details = file_details
    @l_option = l_option
  end

  def display_formatted_files
    if @l_option
      display_fromatted_details
    else
      display_fromatted_file_names
    end
  end

  private

  def display_fromatted_details
    puts "total #{@total_blocks}"
    @file_details.each do |file_detail|
      file_detail =
        { permission: "#{file_detail.permission} ",
          hardlink: file_detail.hardlink_number.rjust(find_max_size(:hardlink_number)),
          owner: "#{file_detail.owner} ".ljust(find_max_size(:owner)),
          group: "#{file_detail.group} ".ljust(find_max_size(:group)),
          filesize: file_detail.filesize.rjust(find_max_size(:filesize)),
          time_stamp: file_detail.time_stamp.strftime('%_m %_d %R'),
          file_name_and_symlink: File.symlink?(file_detail.file_name) ? format_file_name_and_symlink(file_detail) : file_detail.file_name }
      puts file_detail.values.join(' ')
    end
  end

  def display_fromatted_file_names
    format_file_names.transpose.each { |n| puts n.join(' ') }
  end

  # def calc_total_blocks # 複数のファイルからデータを計算したり取得する処理は file_listにあるべき
  #   @file_details.map(&:block_number).sum
  # end

  def find_max_size(symbol = nil)
    @file_details.map(&symbol).map(&:size).max
  end

  def format_file_name_and_symlink(file_detail)
    "#{file_detail.file_name} -> #{file_detail.symlink}"
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
    longest_name_size = find_max_size(:file_name)
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
