require_relative 'test_helper'
require 'csv'
require_relative '../lib/data_extractor'
require_relative '../lib/scrubber'
require_relative '../lib/statewidetest_repository'


class StatewideTestRepositoryTest < Minitest::Test

  def test_it_loads_statewidetest_repository

    str = StatewideTestRepository.new

    assert str.statewidetests.empty?

    str.load_data({
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
    refute str.statewidetests.empty?
  end

end
