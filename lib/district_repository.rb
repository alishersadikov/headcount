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

  def load_data(data_hash)
    csv_files = DataExtractor.extract_data(data_hash)
    build_repo(csv_files[0])
    # binding.pry
    @enrollments.load_data(data_hash)
    # link_enrollments_to_districts
  end

  def build_repo(csv_file)
    kindergarten_data = csv_file[1]
    # kindergarten_data.map { |row|  check_existence(row[:location]) }
    kindergarten_data.each do |row|
     check_existence(row[:location])
    end
  end

  def find_by_name(name)
    @districts[name]

    # @districts.find { |district|  district.name.include?(name.upcase) }
  end

  def find_all_matching(snippet)
    @districts.select { |key, value| value if key.include?(snippet.upcase) }.values

    # @repo.find_all { |district|  district.name.include?(name.upcase) }
  end

  def link_enrollments_to_districts(name)
    enrollments.enrollments[name]
    #
    # @districts.each do |district|
    #   district.enrollment = @enrollments.find_by_name(district.name)
    # end
  end
  private

  def check_existence(name)
    @districts[name.upcase] = District.new({ name: name }, self) if !find_by_name(name)
    # @repo << District.new({ :name => name }) if !find_by_name(name)
  end

end
