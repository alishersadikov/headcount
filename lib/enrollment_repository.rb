require 'csv'
require_relative 'enrollment'

class EnrollmentRepository
  attr_reader :repo

  def initialize
    @repo = []
  end

  def load_data(data_hash)
    filename = data_hash[:enrollment][:kindergarten]
    contents = CSV.open filename, headers: true, header_converters: :symbol
    contents.each do |row|
      @repo << Enrollment.new( { :name => row[:location],
                                 :kindergarten_participation => { row[:timeframe].to_i => row[:data][0..4].to_f  } } )
    end
    format_repo!
  end

  def find_by_name(district_name)
    @repo.find { |enrollment|  enrollment.name.include?(district_name.upcase) }
  end

  def format_repo!
    grouped_repo = @repo.group_by { |enrollment| enrollment.name }
    @repo = grouped_repo.map do |name, enrollments|
      sorted = sort_by_year(enrollments)
      Enrollment.new({:name => name, :kindergarten_participation => extract_annual_data(sorted) })
    end
  end

  def sort_by_year(enrollments)
    enrollments.sort_by { |enrollment|  enrollment.kindergarten_participation.keys.first }
  end

  def extract_annual_data(district_enrollment)
    year_data_pairs = district_enrollment.map do |enrollment|
      enrollment.kindergarten_participation
    end
    merge_into_one_hash(year_data_pairs)
  end

  def merge_into_one_hash(year_data_pairs)
    year_data_pairs.reduce({}) { |result, data| result.merge(data) }
  end
end
