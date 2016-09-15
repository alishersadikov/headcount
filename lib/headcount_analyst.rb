require_relative "../lib/district_repository"
require_relative '../lib/scrubber'

class HeadcountAnalyst
  include Scrubber
  attr_reader :district_repo

  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(district_1, district_2)
    district_1_average = calculate_average(district_1)
    district_2_average = calculate_average(district_2[:against])
    truncate_number(district_1_average / district_2_average)
  end

  def kindergarten_participation_rate_variation_trend(district_1, district_2)
    district_1_data = extract_data(district_1)
    district_2_data = extract_data(district_2[:against])
    keys = district_1_data.keys
    values_1 = district_1_data.values
    values_2 = district_2_data.values
    zipped = values_1.zip(values_2)
    divided = zipped.map { |sub_array| (truncate_number(sub_array[0]/sub_array[1])) }
    keys.zip(divided).to_h
  end

  private

  def calculate_average(district_name)
    data = extract_data(district_name).values
    average = data.inject(:+)/data.size
    truncate_number(average)
  end

  def extract_data(district_name)
    @district_repo.enrollments.find_by_name(district_name).kindergarten
  end

end
