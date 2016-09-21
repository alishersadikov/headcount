require 'csv'
require_relative '../lib/enrollment'
require_relative '../lib/data_extractor'
require_relative '../lib/cleaner'

class EnrollmentRepository
  attr_reader :enrollments
  include Cleaner

  def initialize
    @enrollments = {}
  end

  def load_data(file_tree)
    contents = DataExtractor.extract_data(file_tree[:enrollment])
    contents.map { |csv_files|  build_enrollments(csv_files) }
  end

  def find_by_name(district_name)
    enrollments[district_name.upcase]
  end

  private

  def build_enrollments(csv_files)
    csv_files[1].map do |row|
      if find_by_name(row[:location])
        fill_this_enrollment(csv_files, row)
      else
        create_new_enrollment(csv_files, row)
      end
    end
  end

  def fill_this_enrollment(csv_files, row)
    e = find_by_name(row[:location])
    attribute = csv_files[0]
    e.send(attribute)[row[:timeframe].to_i] = truncate_number(row[:data].to_f)
  end

  def create_new_enrollment(csv_files, row)
    name = row[:location].upcase
    @enrollments[name] = Enrollment.new( { :name => name,
      csv_files[0]=>{row[:timeframe].to_i=>truncate_number(row[:data].to_f)}})
  end
end
