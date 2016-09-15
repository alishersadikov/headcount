require 'csv'
require_relative '../lib/enrollment'
require_relative '../lib/data_extractor'
require_relative '../lib/scrubber'

class EnrollmentRepository
  include Scrubber
  attr_reader :enrollments

  def initialize
    @enrollments = {}
  end

  def load_data(data_hash)
    contents = DataExtractor.extract_data(data_hash)
    contents.map { |csv_files|  build_enrollments(csv_files) }
    # binding.pry
  end

  def find_by_name(district_name)
        @enrollments[district_name.upcase]
    # @enrollments.find { |enrollment|  enrollment.name.include?(district_name.upcase) }
  end

  private

  def build_enrollments(csv_files)
    csv_files[1].map do |row|
      find_by_name(row[:location]) ? fill_this_enrollment(csv_files, row) : create_new_enrollment(csv_files, row)
    end
  end

  def fill_this_enrollment(csv_files, row)
    enrollment = find_by_name(row[:location])
    attribute = csv_files[0]
    enrollment.send(attribute)[row[:timeframe].to_i] = truncate_number(row[:data].to_f)

    # enrollment = find_by_name(row[:location])
    # attribute = csv_files[0]
    # enrollment.send(attribute)[row[:timeframe].to_i] = truncate_number(row[:data].to_f)
  end

  def create_new_enrollment(csv_files, row)
    @enrollments[row[:location].upcase] = Enrollment.new( { :name => row[:location],
                                                      csv_files[0] => { row[:timeframe].to_i => truncate_number(row[:data].to_f) } } )
    # @enrollments << Enrollment.new( { :name => row[:location],
    #                            csv_files[0] => { row[:timeframe].to_i => truncate_number(row[:data].to_f) } } )

  end
end
