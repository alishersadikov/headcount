require_relative "../lib/district_repository"
require_relative '../lib/scrubber'

class HeadcountAnalyst
  include Scrubber
  attr_reader :district_repo

  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(district_1, district_2)
    district_1_average = calculate_average(district_1, "kindergarten")
    district_2_average = calculate_average(district_2[:against], "kindergarten")
    truncate_number(district_1_average / district_2_average)
  end

  def kindergarten_participation_rate_variation_trend(district_1, district_2)
    district_1_data = extract_data(district_1, "kindergarten")
    district_2_data = extract_data(district_2[:against], "kindergarten")
    keys = district_1_data.keys
    zipped = district_1_data.values.zip(district_2_data.values)
    quocients = zipped.map do |data_pair|
      (truncate_number(data_pair[0]/data_pair[1]))
    end
    keys.zip(quocients).to_h
  end

  def kindergarten_participation_against_high_school_graduation(district_name)
    kindergarten_variation = kindergarten_participation_rate_variation(district_name, :against => "COLORADO")
    district_graduation_average = calculate_average(district_name, "graduation_rate_by_year")
    state_graduation_average = calculate_average("COLORADO", "graduation_rate_by_year")
    graduation_variation = district_graduation_average / state_graduation_average
    graduation_variation == 0 ? 0 : truncate_number(kindergarten_variation / graduation_variation)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(parameter)
    district_name = parameter[:for]
    if district_repo.find_by_name(district_name)
      kindergarten_participation_against_high_school_graduation(district_name).between?(0.6, 1.5)
    elsif district_name == "STATEWIDE"
      calculate_statewide_correlation
    elsif parameter[:across]
      array = parameter[:across]
      correlation_across_multiple_districts(array)
    end
  end

  def top_statewide_test_year_over_year_growth(grade, subject)
    district_repo.statewidetests
    binding.pry
    # we need to iterate over district name and to get access to 3rd or 8th grade
    # in our loop we might have find_by_name method and we can grab district grade data
    # that way we can build a hash/array with all grade date
  end




  private

  def correlation_across_multiple_districts(districts)
    district_correlations = districts.map do |district|
      kindergarten_participation_correlates_with_high_school_graduation(for: district)
    end
    district_correlations.count(true).to_f / district_correlations.count > 0.70
  end

  def calculate_statewide_correlation
    district_correlations = district_repo.districts.map do |name, district|
      kindergarten_participation_correlates_with_high_school_graduation(for: name)
    end
    district_correlations.count(true).to_f / district_correlations.count > 0.70
  end

  def calculate_average(district_name, attribute)
    data = extract_data(district_name, attribute).values
    average = data.inject(:+)/data.size
    truncate_number(average)
  end

  def extract_data(district_name, attribute)
    district_repo.enrollments.find_by_name(district_name).send(attribute)
  end
end
