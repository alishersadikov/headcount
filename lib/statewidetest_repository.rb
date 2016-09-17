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
    attribute = csv_files[0]
    if attribute == :third_grade || :eight_grade
      build_grade_hash(row, attribute)
    else
      build_test_hash
    end
  end

  def build_grade_hash(row, attribute)
    swt = find_by_name(row[:location])
    # if row[:score].nil?
    #   binding.pry
    # end
    score = row[:score] || row[:race_ethnicity] ||'blank'
    if !swt.send(attribute)[row[:timeframe].to_i].nil?
        swt.send(attribute)[row[:timeframe].to_i].store(score.downcase.to_sym,truncate_number(row[:data].to_f))
    else
      swt.send(attribute)[row[:timeframe].to_i] = {score.downcase.to_sym=>truncate_number(row[:data].to_f)}
    end
  end

  def build_test_hash


  end
  #
  #   statewidetest = find_by_name(row[:location])
  #   attribute = csv_files[0]
  #   # if statewidetest.third_grade.values.find { |hash| hash.has_key?(row[:score]) }
  #     # binding.pry
  #     # h.merge!(key: "bar")
  #     # statewidetest.send(attribute).merge!(row[:timeframe].to_i => {row[:score] => truncate_number(row[:data].to_f)})
  #     # statewidetest.send(attribute)[row[:timeframe].to_i] = {row[:score]] => truncate_number(row[:data].to_f)}
  #   #
  #   # else
  #   #   binding.pry
  #   statewidetest.send(attribute)[row[:timeframe].to_i] = truncate_number(row[:data].to_f)
  #
  #     # statewidetest.send(attribute)[row[:timeframe].to_i] = {row[:score]=>truncate_number(row[:data].to_f)}
  #   end
  # end

  def create_new_statewidetest(csv_files, row)

    #1st scenario is when I am reading data for 3rd grade and 8th grade
    #2nd scenario is when I am reading data for specific subjects
    score_or_race = row[:score] || row[:race_ethnicity]
    @statewidetests[row[:location].upcase] = Statewidetest.new(
    { :name => row[:location], csv_files[0]=> {row[:timeframe].to_i=>{score_or_race=>truncate_number(row[:data].to_f)}}} )

      # {row[:timeframe].to_i=>{row[:score]=>truncate_number(row[:data].to_f)}}})
  end
end
