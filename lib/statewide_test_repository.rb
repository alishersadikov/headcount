require 'csv'
require_relative '../lib/statewide_test'
require_relative '../lib/data_extractor'
require_relative '../lib/cleaner'

class StatewideTestRepository
  include Cleaner
  attr_reader :statewidetests

  def initialize
    @statewidetests = {}
  end

  def load_data(file_tree)
    contents = DataExtractor.extract_data(file_tree[:statewide_testing])
    contents.map { |csv_objects|  build_statewidetests(csv_objects)}
  end

  def find_by_name(district_name)
    statewidetests[district_name.upcase]
  end

  private

  def build_statewidetests(csv_objects)
    csv_objects[1].map do |row|
      if find_by_name(row[:location])
        fill_this_statewidetest(csv_objects, row)
      else
         create_new_statewidetest(csv_objects, row)
      end
    end
  end

  def fill_this_statewidetest(csv_objects, row)
    attribute = csv_objects[0]
    build_grade_and_test_hash(row, attribute)
  end

  def build_grade_and_test_hash(row, attribute)
    swt = find_by_name(row[:location])
    score_or_race = row[:score] || row[:race_ethnicity] ||'blank'
    if !swt.send(attribute)[row[:timeframe].to_i].nil?
      fill_the_year_key(row, attribute, swt, score_or_race)
    else
      create_a_year_key(row, attribute, swt, score_or_race)
    end
  end

  def fill_the_year_key(row, attribute, swt, score_or_race)
    year = row[:timeframe].to_i
    cleaned_key = clean_symbol(score_or_race).downcase.to_sym
    cleaned_data = truncate_number(row[:data].to_f)
    swt.send(attribute)[year].store(cleaned_key, cleaned_data)
  end

  def create_a_year_key(row, attribute, swt, score_or_race)
    year = row[:timeframe].to_i
    cleaned_key = clean_symbol(score_or_race).downcase.to_sym
    cleaned_data = truncate_number(row[:data].to_f)
    swt.send(attribute)[year] = {cleaned_key => cleaned_data}
  end

  def create_new_statewidetest(csv_objects, row)
    score_or_race = row[:score] || row[:race_ethnicity] || "blank"
    year = row[:timeframe].to_i
    cleaned_key = clean_symbol(score_or_race).downcase.to_sym
    cleaned_data = truncate_number(row[:data].to_f)
    name = row[:location].upcase

    @statewidetests[name] = StatewideTest.new(
    {:name => name, csv_objects[0]=> {year=>{cleaned_key => cleaned_data}}})
  end
end
