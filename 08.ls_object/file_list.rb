# frozen_string_literal: true

class FileList
  attr_reader :file_names_list

  def initialize(options)
    @options = options
    @file_names_list = build_file_names_list
  end

  private

  def build_file_names_list
    file_names = Dir.glob('*', @options['a'] ? File::FNM_DOTMATCH : 0).sort
    @options['r'] ? file_names.reverse : file_names
  end
end
