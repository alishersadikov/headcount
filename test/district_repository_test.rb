require_relative "test_helper"
require_relative "../lib/district_repository"
require_relative "../lib/enrollment_repository"

class DistrictRepositoryTest < Minitest::Test

  def test_it_loads_the_repo_from_the_file
    dr = DistrictRepository.new

    assert dr.districts.empty?

    dr.load_data({:enrollment => { :kindergarten => "./data/Kindergartners in full-day program.csv"}})
    refute dr.districts.empty?
  end

  def test_it_finds_by_district_name
    dr = DistrictRepository.new

    dr.load_data({:enrollment => { :kindergarten => "./data/Kindergartners in full-day program.csv"}})

    district = dr.find_by_name("ACADEMY 20")

    assert_equal "ACADEMY 20", district.name
    assert_equal nil, dr.find_by_name("Eric")
  end

  def test_it_finds_all_matching_districts
    dr = DistrictRepository.new

    dr.load_data({:enrollment => { :kindergarten => "./data/Kindergartners in full-day program.csv"}})

    districts = dr.find_all_matching("ACADEMY 20")

    assert_equal "ACADEMY 20", districts.first.name

    districts.each do |district|
        assert_equal "ACADEMY 20", district.name
    end
  end

  def test_it_takes_district_snippet_and_returns_all_matching_districts
    dr = DistrictRepository.new

    dr.load_data({:enrollment => { :kindergarten => "./data/Kindergartners in full-day program.csv"}})
    districts = dr.find_all_matching("we")

    assert_equal "WELD COUNTY RE-1", districts.first.name
    assert_equal "WESTMINSTER 50", districts.last.name
    assert_equal 7, districts.count
  end

  def test_it_extracts_kindergarted_participation_in_year_data
    dr = DistrictRepository.new

    dr.load_data({:enrollment => { :kindergarten => "./data/Kindergartners in full-day program.csv"}})
    district = dr.find_by_name("ACADEMY 20")

    actual = district.enrollment.kindergarten_participation_in_year(2010)
    assert_equal 0.436, actual
  end

  def test_relationship_between_statewidetest_and_district
    dr = DistrictRepository.new
    dr.load_data({
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv",
      :high_school_graduation => "./data/High school graduation rates.csv",
    },
    :statewide_testing => {
      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
      :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
      :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
      :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
    }
  })
  district = dr.find_by_name("ACADEMY 20")
  statewide_test = district.statewide_test

  assert_equal "ACADEMY 20", district.statewide_test.name
  end
end
