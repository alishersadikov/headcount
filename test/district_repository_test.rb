require "./test/test_helper"
require "./lib/district_repository"

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

  def test_it_should_find_by_name
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    district = dr.find_by_name("ACADEMY 20")

    assert_equal "ACADEMY 20", district.name
  end

  def test_it_should_find_by_name
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    districts = dr.find_all_matching("ACADEMY 20")

    assert_equal 11, districts.count

    districts.each do |district|
      assert_equal "ACADEMY 20", district.name
    end
  end

end
