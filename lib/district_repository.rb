require_relative '../lib/district'
require 'csv'

class DistrictRepository
  attr_reader :repo
  def initialize
    @repo = []
  end

  def load_data(file)
    filename = file[:enrollment][:kindergarten]
    contents = CSV.open filename, headers: true, header_converters: :symbol
    build_repository(contents)
  end

  def build_repository(contents)
    contents.map do |row|
      @repo << District.new({ :name => row[:location] })
    end
  end

  def find_by_name(name)
    @repo.find { |district|  district.name.include?(name.upcase) }
  end

  def find_all_matching(name)
    found = @repo.find_all do |district|
      district if district.name.include?(name.upcase)
     end
     unique_names = found.map { |district|  district.name }.uniq
  end
end
