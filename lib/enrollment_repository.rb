require 'csv'
require './lib/enrollment'

class EnrollmentRepository
  attr_reader :repo

  def initialize
    @repo = []
  end

  def load_data(file)
    filename = file[:enrollment][:kindergarten]
    contents = CSV.open filename, headers: true, header_converters: :symbol
    contents.each do |row|
      # require 'pry'; binding.pry
      @repo << Enrollment.new( { :name => row[:location],
                                 :kindergarten_participation => { row[:timeframe].to_i => row[:data].to_f  } } )
    end
    format_repo!
  end

  def find_by_name(district_name)
    @repo.find { |enrollment|  enrollment.name == district_name }
  end

  def format_repo!
    grouped_repo = @repo.group_by { |enrollment| enrollment.name }
    @repo = grouped_repo.map do |name, enrollments|
      sorted = enrollments.sort_by do |enrollment|
        enrollment.kindergarten_participation.keys.first
      end
      kindergarden_data = sorted.map do |enrollment|
        enrollment.kindergarten_participation
      end.reduce({}) { |result, data| result.merge(data) }
      Enrollment.new({:name => name, :kindergarten_participation => kindergarden_data })
    end
  end
end



# The EnrollmentRepository is responsible for holding and searching our Enrollment instances. It offers the following methods:
#
# find_by_name - returns either nil or an instance of Enrollment having done a case insensitive search
# For iteration 0, the instance of this object represents one line of data from the file Kindergartners in full-day program.csv. It's initialized and used like this:
#
# er = EnrollmentRepository.new
# er.load_data({
#   :enrollment => {
#     :kindergarten => "./data/Kindergartners in full-day program.csv"
#   }
# })
# enrollment = er.find_by_name("ACADEMY 20")
# # => <Enrollment>
