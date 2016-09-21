require_relative "test_helper"
require_relative "../lib/district_repository"
require_relative "../lib/enrollment_repository"

class DistrictRepositoryTest < Minitest::Test
  attr_reader :dr

  def setup
    @dr = DistrictRepository.new
  end

  def load_data
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
                                         },
                  :economic_profile => {
                    :median_household_income => "./data/Median household income.csv",
                    :children_in_poverty => "./data/School-aged children in poverty.csv",
                    :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                    :title_i => "./data/Title I students.csv"
                                        }
                  })
  end

  def test_it_loads_the_repo_from_the_file
    assert dr.districts.empty?

    load_data

    refute dr.districts.empty?
  end

  def test_child_repos_are_empty_before_loading_data
    assert_equal ({}), dr.enrollments.enrollments
    assert_equal ({}), dr.statewidetests.statewidetests
    assert_equal ({}), dr.economic_profiles.economic_profiles
  end

  def test_child_repos_are_not_empty_after_loading_data
    load_data

    refute dr.enrollments.enrollments.empty?
    refute dr.statewidetests.statewidetests.empty?
    refute dr.economic_profiles.economic_profiles.empty?
  end

  def test_it_consists_of_district_objects
    load_data

    dr.districts.each do |name, district|
      assert_instance_of District, district
    end
  end

  def test_it_finds_by_district_name
    load_data

    district = dr.find_by_name("ACADEMY 20")

    assert_equal "ACADEMY 20", district.name
  end

  def test_it_returns_nil_if_district_name_does_not_exist
    load_data

    assert_equal nil, dr.find_by_name("Eric")
    assert_equal nil, dr.find_by_name("Blue Valley")
  end

  def test_it_finds_all_matching_districts
    load_data
    districts = dr.find_all_matching("ACADEMY 20")

    assert_equal 1, districts.count
    assert_equal "ACADEMY 20", districts.first.name
  end

  def test_it_takes_district_snippet_and_returns_all_matching_districts
    load_data
    districts = dr.find_all_matching("we")

    assert_equal "WELD COUNTY RE-1", districts.first.name
    assert_equal "WESTMINSTER 50", districts.last.name
    assert_equal 7, districts.count
  end

  def test_it_links_enrollment_to_districts
    load_data

    enrollment_1 = dr.link_enrollments_to_districts("COLORADO")
    enrollment_2 = dr.link_enrollments_to_districts("ADAMS COUNTY 14")

    assert_equal "COLORADO", enrollment_1.name
    assert_equal "ADAMS COUNTY 14", enrollment_2.name
  end

  def test_it_links_statewide_to_districts
    load_data

    statewidetest_1 = dr.link_statewidetests_to_districts("COLORADO")
    statewidetest_2 = dr.link_statewidetests_to_districts("ADAMS COUNTY 14")

    assert_equal "COLORADO", statewidetest_1.name
    assert_equal "ADAMS COUNTY 14", statewidetest_2.name
  end

  def test_it_links_economic_profiles_to_districts
    load_data

    economic_profile_1 = dr.link_economic_profiles_to_districts("COLORADO")
    economic_profile_2 = dr.link_economic_profiles_to_districts("ADAMS COUNTY 14")

    assert_equal "COLORADO", economic_profile_1.name
    assert_equal "ADAMS COUNTY 14", economic_profile_2.name
  end
end
