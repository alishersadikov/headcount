require_relative '../lib/district'
require_relative '../lib/enrollment_repository'
require 'csv'

class DistrictRepository
  attr_reader :repo, :enrollment_repo

  def initialize
    @repo = []
    @enrollment_repo = EnrollmentRepository.new
  end

  def load_data(data_hash)
    filename = data_hash[:enrollment][:kindergarten]
    contents = CSV.open filename, headers: true, header_converters: :symbol
    build_repository(contents)
    @enrollment_repo = @enrollment_repo.load_data(data_hash)
  end

  def build_repository(contents)
    contents.map { |row|  check_existence(row[:location]) }
  end

  def find_by_name(name)
    @repo.find { |district|  district.name.include?(name.upcase) }
  end

  def find_all_matching(name)
    @repo.find_all { |district|  district.name.include?(name.upcase) }


    # found = @repo.find_all do |district|
    #   district if district.name.include?(name.upcase)
    #  end
    #  unique_names = found.map { |district|  district.name }.uniq
  end

  private

  def check_existence(name)
    @repo << District.new({ :name => name }) if !find_by_name(name)
  end


end
