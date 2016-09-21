require_relative '../lib/economic_profile'
require_relative '../lib/scrubber'
require_relative '../lib/data_extractor'

class EconomicProfileRepository
  include Scrubber
  attr_reader :economic_profiles

  def initialize
    @economic_profiles = {}
  end

  def load_data(file_tree)
    contents = DataExtractor.extract_data(file_tree[:economic_profile])
    contents.map { |csv_objects|  build_economic_profiles(csv_objects) }
  end

  def find_by_name(district_name)
    economic_profiles[district_name.upcase]
  end

  private

  def build_economic_profiles(csv_objects)
    csv_objects[1].map do |row|
      if find_by_name(row[:location])
         fill_this_economic_profile(csv_objects, row)
      else
        create_new_economic_profile(csv_objects, row)
      end
    end
  end

  def fill_this_economic_profile(csv_objects, row)
    attribute = csv_objects[0]
    cleaned_data = truncate_number(row[:data].to_f)
    if attribute == :median_household_income
      fill_median_household_income(row)
    elsif attribute == :free_or_reduced_price_lunch
      fill_free_or_reduced_price_lunch(row)
    else
      ep = find_by_name(row[:location])
      ep.send(attribute)[row[:timeframe].to_i] = cleaned_data
    end
  end

  def fill_median_household_income(row)
    attribute = :median_household_income
    cleaned_data = truncate_number(row[:data].to_f)
    year = create_array(row[:timeframe])
    ep = find_by_name(row[:location])
    ep.send(attribute)[year] = cleaned_data
  end

  def fill_free_or_reduced_price_lunch(row)
    year = row[:timeframe].to_i
    attribute = :free_or_reduced_price_lunch
    ep = find_by_name(row[:location])
    string = "Eligible for Free or Reduced Lunch"
    row[:poverty_level] == string ? percent_or_number(row,year,attribute) : nil
  end

  def percent_or_number(row, year, attribute)
    if row[:dataformat] == "Percent"
      fill_free_or_reduced_price_lunch_with_percent(row, year, attribute)
    elsif row[:dataformat] == "Number"
      fill_free_or_reduced_price_lunch_with_number(row, year, attribute)
    end
  end

  def fill_free_or_reduced_price_lunch_with_percent(row, year, attribute)
    cleaned_data = truncate_number(row[:data].to_f)
    ep = find_by_name(row[:location])
    if ep.send(attribute)[year].nil?
      ep.send(attribute)[year] = {:percentage=>cleaned_data}
    else
      ep.send(attribute)[year].store(:percentage, cleaned_data)
    end
  end

  def fill_free_or_reduced_price_lunch_with_number(row, year, attribute)
    cleaned_data = truncate_number(row[:data].to_f)
    ep = find_by_name(row[:location])
    if ep.send(attribute)[year].nil?
      ep.send(attribute)[year] = {:total=>row[:data].to_i}
    else
      ep.send(attribute)[year].store(:total, row[:data].to_i)
    end
  end

  def create_new_economic_profile(csv_objects, row)
    attribute = csv_objects[0]
    year = median_household_income_or_else(row, attribute)
    cleaned_data = truncate_number(row[:data].to_f)
    @economic_profiles[row[:location].upcase] = EconomicProfile.new( {
      :name => row[:location].upcase, attribute=>{year=>cleaned_data}})
  end

  def median_household_income_or_else(row, attribute)
    if attribute == :median_household_income
      year = create_array(row[:timeframe])
    else
      year = row[:timeframe].to_i
    end
  end
end
