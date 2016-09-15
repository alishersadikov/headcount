require_relative 'test_helper'
require_relative '../lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test

  def test_it_loads_repository
    er = EnrollmentRepository.new

    assert er.repo.empty?

    er.load_data({:enrollment => { :kindergarten => "./data/Kindergartners in full-day program.csv"}})

    refute er.repo.empty?
  end

  def test_it_finds_by_district_name
    er = EnrollmentRepository.new

    er.load_data({:enrollment => { :kindergarten => "./data/Kindergartners in full-day program.csv"}})

    enrollment = er.find_by_name("ACADEMY 20")

    assert_equal "ACADEMY 20", enrollment.name
  end

  def test_it_finds_by_partial_district_name
    er = EnrollmentRepository.new

    er.load_data({:enrollment => { :kindergarten => "./data/Kindergartners in full-day program.csv"}})

    enrollment = er.find_by_name("Colorado")

    assert_equal "COLORADO", enrollment.name
  end
end
