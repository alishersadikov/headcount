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
end
