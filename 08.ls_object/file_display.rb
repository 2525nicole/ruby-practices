# frozen_string_literal: true

class FileDisplay
  def initialize(args)
    @displayed_file_information = args[:displayed_file_information]
    options = args[:options]
    if options['l']
      @formatted_file_details = format_file_details
    else
      @formatted_file_names = format_file_names
    end
  end

  def display_details
    puts "total #{calc_total_blocks}"
    @formatted_file_details.each do |d|
      displayed_result = []
      d.each do |k, v|
        next if k == :block_number

        displayed_result << v
      end
      puts displayed_result.join(' ')
    end
  end

  def display_file_names
    @formatted_file_names.transpose.map { |n| puts n.join(' ') }
  end

  private

  def calc_total_blocks
    @displayed_file_information.map { |f| f[:block_number] }.sum
  end

  def format_file_details
    file_details_hash = @displayed_file_information
    right_alignment_targets = :hardlink_number, :filesize
    left_alignment_targets = :owner, :group
    align_values_right(file_details_hash, right_alignment_targets)
    align_values_left(file_details_hash, left_alignment_targets)
    file_details_hash
  end

  def align_values_right(target_hash, target_key)
    target_key.each do |k|
      target_key = target_hash.map { |f| f[k] }
      longest_char = target_key.map(&:size).max
      target_hash.map do |f|
        f[k] = " #{f[k].rjust(longest_char)}"
      end
    end
  end

  def align_values_left(target_hash, target_key)
    target_key.each do |k|
      target_key = target_hash.map { |f| f[k] }
      longest_char = target_key.map(&:size).max
      target_hash.map do |f|
        f[k] =
          if k == :group
            " #{f[k].ljust(longest_char)}"
          else
            f[k].ljust(longest_char).to_s
          end
      end
    end
  end

  def format_file_names
    max_columns = 3
    display_width = find_display_width
    columns_number = calc_columns_number(max_columns, display_width)
    columns_width = calc_columns_width(display_width, columns_number)
    rows_number = calc_rows_number(columns_number)

    left_alignment_file_names = @displayed_file_information.map { |d| d.ljust(columns_width - 1) }
    file_names_per_rows = left_alignment_file_names.each_slice(rows_number).to_a
    file_names_per_rows.map { |element| element.values_at(0...rows_number) }
  end

  def find_display_width
    `tput cols`.to_i
  end

  def calc_columns_number(max_columns, display_width)
    longest_name_size = @displayed_file_information.max_by(&:size).size
    minus_columns = (0...max_columns).find { longest_name_size < display_width / (max_columns - _1) } || max_columns - 1
    max_columns - minus_columns
  end

  def calc_columns_width(display_width, columns_number)
    display_width / columns_number
  end

  def calc_rows_number(columns_number)
    (@displayed_file_information.size / columns_number.to_f).ceil
  end
end
