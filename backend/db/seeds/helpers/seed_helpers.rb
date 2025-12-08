# frozen_string_literal: true

def read_seeds_data(file_path)
  File.new(file_path, 'w+') unless File.exist?(file_path)
  Psych.safe_load(File.read(file_path)) || []
end
