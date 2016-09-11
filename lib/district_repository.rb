require './lib/district'
require 'csv'

class DistrictRepository
  attr_reader :repo
  def initialize
    @repo = []
  end

  def load_data(file)
    filename = file[:enrollment][:kindergarten]
    contents = CSV.open filename, headers: true, header_converters: :symbol
    contents.each do |row|
      @repo << District.new({ :name => row[:location] })
    end
    return @repo
  end

  def find_by_name(name)
    @repo.find { |district|  district.name == name }
  end

  def find_all_matching(name)
    @repo.find_all { |district|  district.name == name }
  end
end

# if __FILE__ == $0
#   dr = DistrictRepository.new
#   dr.load_data( { :graduation => { :kindergarten => "./data/Kindergartners in full-day program.csv",
#                                     :high_school => "./data/Kindergartners in full-day program.csv"},
#
#                   :enrollment =>  { :kindergarten => "./data/Kindergartners in full-day program.csv",
#                                     :high_school => "./data/Kindergartners in full-day program.csv"}} )
# end
