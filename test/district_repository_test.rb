require_relative "test_helper"
require_relative "../lib/district_repository"

class DistrictRepositoryTest < Minitest::Test

  def test_it_loads_the_repo_from_the_file
    dr = DistrictRepository.new

    assert dr.repo.empty?

    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })

    refute dr.repo.empty?
  end

  def test_it_finds_by_district_name
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    district = dr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", district.name
    assert_equal nil, dr.find_by_name("Eric")
  end

  def test_it_finds_all_matching_districts
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    districts = dr.find_all_matching("ACADEMY 20")

    assert_equal "ACADEMY 20", districts.first.name

    districts.each do |district|
        assert_equal "ACADEMY 20", district.name
    end
  end

  def test_it_takes_district_snippet_and_returns_all_matching_districts
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    districts = dr.find_all_matching("WE")
    # assert_equal "COLORADO", districts.first.name
    # assert_equal "COLORADO SPRINGS 11", districts[5].name
    assert_equal 2, districts.count
    end
end
