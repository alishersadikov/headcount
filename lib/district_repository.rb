require_relative '../lib/district'
require_relative '../lib/enrollment_repository'
require_relative '../lib/data_extractor'
require 'csv'

class DistrictRepository
  attr_reader :districts,
              :enrollments

  def initialize
    @districts = {}
    @enrollments = EnrollmentRepository.new
  end

  def load_data(file_tree)
    csv_files = DataExtractor.extract_data(file_tree)
    build_repo(csv_files[0])
    @enrollments.load_data(file_tree)

  end

  def build_repo(csv_file)
    kindergarten_data = csv_file[1]
    kindergarten_data.map { |row|  check_existence(row[:location]) }
  end

  def find_by_name(name)
    @districts[name]
  end

  def find_all_matching(snippet)
    @districts.select { |key, value| value if key.include?(snippet.upcase) }.values
  end

  def link_enrollments_to_districts(name)
    enrollments.enrollments[name]
  end

  private

  def check_existence(name)
    @districts[name.upcase] = District.new({ name: name }, self) if !find_by_name(name)
  end
end
