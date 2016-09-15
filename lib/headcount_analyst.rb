require_relative "../lib/district_repository"

class HeadcountAnalyst
  attr_reader :district_repo

  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(district_1, district_2)
    district_1_average = calculate_average(district_1)
    district_2_average = calculate_average(district_2[:against])
    (district_1_average / district_2_average).round(3)
  end

  def kindergarten_participation_rate_variation_trend(district_1, district_2)
    district_1_data = extract_data(district_1)
    district_2_data = extract_data(district_2[:against])
    keys = district_1_data
    values_1 = district_1_data.values
    values_2 = district_2_data.values
    zipped = values_1.zip(values_2)
    zipped.map { |sub_array| (sub_array[0]/sub_array[1]).round(3) }

    binding.pry
  end

  private

  def calculate_average(district_name)
    data = extract_data(district_name).values
    average = data.inject(:+)/data.size
    average.round(3)
  end

  def extract_data(district_name)
    @district_repo.enrollment_repo.find_by_name(district_name).kindergarten_participation
  end

end
