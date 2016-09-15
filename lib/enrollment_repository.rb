require 'csv'
require_relative 'enrollment'
require_relative '../lib/data_extractor'

class EnrollmentRepository
  attr_reader :repo

  def initialize
    @repo = []
  end

  def load_data(data_hash)
    contents = DataExtractor.extract_data(data_hash)
    contents.each do |csv|
      csv[1].each do |row|
        if find_by_name(row[:location])
          enrollment = find_by_name(row[:location])
          enrollment.send(csv[0])[row[:timeframe].to_i] = row[:data][0..4].to_f
        else
          @repo << Enrollment.new( { :name => row[:location],
                                  csv[0] => { row[:timeframe].to_i => row[:data][0..4].to_f } } )
          # {name: 'Adams 20', kindergarten: {...}}
        end
      end
    end
    binding.pry
    # format_repo!
  end

  def load_data(data_hash)
    contents = DataExtractor.extract_data(data_hash)
    contents.each do |csv|
      csv[1].each do |row|
        if find_by_name(row[:location])
          enrollment = find_by_name(row[:location])
          # enrollment.assign_whatever
          # assign_wahtever(enrollment)
          enrollment.send(csv[0])[row[:timeframe].to_i] = row[:data][0..4].to_f
        else
          @repo << Enrollment.new( { :name => row[:location],
                                  csv[0] => { timeframe(row) => row[:data][0..4].to_f } } )
          # {name: 'Adams 20', kindergarten: {...}}
        end
      end
    end
    binding.pry
    # format_repo!
  end

  def find_by_name(district_name)
    @repo.find { |enrollment|  enrollment.name.include?(district_name.upcase) }
  end

  private

  def format_repo!
    grouped_repo = @repo.group_by { |enrollment| enrollment.name }
    @repo = grouped_repo.map do |name, enrollments|
      sorted = sort_by_year(enrollments)
      Enrollment.new({:name => name, :kindergarten => extract_annual_data(sorted) })
    end
  end

  def sort_by_year(enrollments)
    # [
    #   {2006 => 1, 2007 => 1}
    #   {2006 => 1, 2007 => 1}
    #   {2007 => 1, 2006 => 1, 2005 => 1}
    # ]
    enrollments.sort_by { |enrollment|  enrollment.kindergarten.keys.sort.first }

  #   enrollments.sort { |a, b|  [2006, 2005, 2007].first <=> [2007, 2006, 2005].sort.first }
  #   enrollments.sort { |a, b|  [2005, 2006, 2007].first <=> [2005, 2006, 2007].first }
  end

  def extract_annual_data(district_enrollment)
    year_data_pairs = district_enrollment.map do |enrollment|
      enrollment.kindergarten
    end
    merge_into_one_hash(year_data_pairs)
  end

  def merge_into_one_hash(year_data_pairs)
    year_data_pairs.reduce({}) { |result, data| result.merge(data) }
  end
end
