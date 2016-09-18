require_relative 'test_helper'
require 'csv'
require_relative '../lib/data_extractor'
require_relative '../lib/statewidetest_repository'



class StatewideTestRepositoryTest < Minitest::Test
  attr_reader   :str

  def setup
    @str = StatewideTestRepository.new
  end

  def load_data
    str.load_statewide_data({
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
      })
  end

  def test_it_loads_statewidetest_repository
    assert str.statewidetests.empty?

    load_data


    refute str.statewidetests.empty?
  end

  def test_it_finds_by_name
    load_data

    found = str.find_by_name("academy 20")

    assert_equal "ACADEMY 20", found.name
  end
end
