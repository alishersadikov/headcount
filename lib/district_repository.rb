require_relative '../lib/district'
require_relative '../lib/enrollment_repository'
require_relative '../lib/statewide_test_repository'
require_relative '../lib/economic_profile_repository'
require_relative '../lib/data_extractor'
require 'csv'

class DistrictRepository
  attr_reader :districts,
              :enrollments,
              :statewidetests,
              :economic_profiles

  def initialize
    @districts         = {}
    @enrollments       = EnrollmentRepository.new
    @statewidetests    = StatewideTestRepository.new
    @economic_profiles = EconomicProfileRepository.new
  end

  def load_data(file_tree)
    csv_files = DataExtractor.extract_data(file_tree[:enrollment])
    build_repo(csv_files[0])
    @enrollments.load_data(file_tree)       if file_tree[:enrollment]
    @statewidetests.load_data(file_tree)    if file_tree[:statewide_testing]
    @economic_profiles.load_data(file_tree) if file_tree[:economic_profile]
  end

  def build_repo(csv_file)
    kindergarten_data = csv_file[1]
    kindergarten_data.map { |row|  check_existence(row[:location]) }
  end

  def find_by_name(name)
    @districts[name]
  end

  def find_all_matching(snippet)
    @districts.select do |key, value|
      value if key.include?(snippet.upcase)
    end.values
  end

  def link_enrollments_to_districts(name)
    enrollments.enrollments[name]
  end

  def link_statewidetests_to_districts(name)
    statewidetests.statewidetests[name]
  end

  def link_economic_profiles_to_districts(name)
    economic_profiles.economic_profiles[name]
  end

  private

  def check_existence(name)
    @districts[name.upcase] = District.new(
                        { name: name }, self) if !find_by_name(name)
  end
end
