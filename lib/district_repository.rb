require_relative '../lib/district'
require_relative '../lib/enrollment_repository'
require_relative '../lib/data_extractor'
require 'csv'

class DistrictRepository
  attr_reader :repo,
              :enrollment_repo

  def initialize
    @repo = []
    @enrollment_repo = EnrollmentRepository.new
  end

  def load_data(data_hash)
    csv_files = DataExtractor.extract_data(data_hash)
    build_repo(csv_files[0])
    @enrollment_repo.load_data(data_hash)
    link_enrollments_to_districts
  end

  def build_repo(csv_file)
    kindergarten_data = csv_file[1]
    kindergarten_data.map { |row|  check_existence(row[:location]) }
  end

  def find_by_name(name)
    @repo.find { |district|  district.name.include?(name.upcase) }
  end

  def find_all_matching(name)
    @repo.find_all { |district|  district.name.include?(name.upcase) }
  end

  private

  def check_existence(name)
    @repo << District.new({ :name => name }) if !find_by_name(name)
  end

  def link_enrollments_to_districts
    @repo.each do |district|
      district.enrollment = @enrollment_repo.find_by_name(district.name)
      # district.enrollment = @enrollment_repo.repo.find do |enrollment|
      #   enrollment.name == district.name
      # end
    end
  end
end
