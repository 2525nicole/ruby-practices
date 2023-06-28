# frozen_string_literal: true

class LsExecutionResult
  def initialize(options)
    @displayed_file_informations = options['l'] ? FileDetails.new(options) : FileList.new(options)
    @displayed_file_names = @displayed_file_informations.file_names_list
  end

  def display(options)
    return if @displayed_file_names.empty?

    if options['l']
      display_file_details
    else
      display_file_names
    end
  end

  private

  def display_file_details
    total_blocks = @displayed_file_informations.total_blocks
    file_details_hash = @displayed_file_informations.file_details
    alignment_targets_keys = :hardlinks, :owners, :groups, :filesizes
    alignment_targets_keys.each do |k|
      alignment_targets = file_details_hash[k]
      longest_char = alignment_targets.map(&:size).max
      file_details_hash[k] = alignment_targets.map { |t| " #{t.rjust(longest_char)}" }
    end
    puts "total #{total_blocks}"
    display_result(file_details_hash.values)
  end

  def display_file_names
    max_columns = 3
    display_width = find_display_width
    columns_number = calc_columns_number(max_columns, display_width)
    columns_width = calc_columns_width(display_width, columns_number)
    rows_number = calc_rows_number(columns_number)

    left_alignment_file_names = @displayed_file_names.map { |d| d.ljust(columns_width - 1) }
    file_names_per_rows = left_alignment_file_names.each_slice(rows_number).to_a
    align_elements_number = file_names_per_rows.map { |element| element.values_at(0...rows_number) }
    display_result(align_elements_number)
  end

  def display_result(result)
    result.transpose.map { |r| puts r.join(' ') }
  end

  def find_display_width
    `tput cols`.to_i
  end

  def calc_columns_number(max_columns, display_width)
    longest_name_size = @displayed_file_names.max_by(&:size).size
    minus_columns = (0...max_columns).find { longest_name_size < display_width / (max_columns - _1) } || max_columns - 1
    max_columns - minus_columns
  end

  def calc_columns_width(display_width, columns_number)
    display_width / columns_number
  end

  def calc_rows_number(columns_number)
    (@displayed_file_names.size / columns_number.to_f).ceil
  end
end
