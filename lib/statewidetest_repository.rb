require 'csv'
require_relative '../lib/statewidetest'
require_relative '../lib/data_extractor'
require_relative '../lib/scrubber'

class StatewideTestRepository
  include Scrubber
  attr_reader :statewidetests

  def initialize
    @statewidetests = {}
  end

  def load_data(file_tree)
    contents = DataExtractor.extract_data(file_tree)
    contents.map { |csv_files|  build_statewidetests(csv_files) }
    binding.pry
  end

  def find_by_name(district_name)
    statewidetests[district_name.upcase]
  end

  private

  def build_statewidetests(csv_files)
    csv_files[1].map do |row|
      find_by_name(row[:location]) ? fill_this_statewidetest(csv_files, row) : create_new_statewidetest(csv_files, row)
    end
  end

  def fill_this_statewidetest(csv_files, row)
    statewidetest = find_by_name(row[:location])
    attribute = csv_files[0]
    statewidetest.send(attribute)[row[:timeframe].to_i] = truncate_number(row[:data].to_f)
  end

  def create_new_statewidetest(csv_files, row)
    @statewidetests[row[:location].upcase] = Statewidetest.new( { :name => row[:location],
      csv_files[0]=>{row[:timeframe].to_i=>truncate_number(row[:data].to_f)}})
  end
end