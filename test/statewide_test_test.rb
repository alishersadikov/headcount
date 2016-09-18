require_relative 'test_helper'
require 'csv'
require_relative '../lib/data_extractor'
require_relative '../lib/scrubber'
require_relative '../lib/statewide_test'
require_relative '../lib/statewide_test_repository'
require_relative '../lib/errors.rb'


class StatewideTestTest < Minitest::Test
  attr_reader   :str

  def setup
    @str = StatewideTestRepository.new
  end

  def load_data
    str.load_data(
                  {
                    :statewide_testing => {
                      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                      :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                      :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                                             }
                    }
                   )
  end

  def test_it_extracts_proficiency_by_grade_data_for_grade_3
    load_data
    statewide_test = str.find_by_name("ACADEMY 20")

    expected = { 2008 => {:math=>0.857, :reading=>0.866, :writing=>0.671 },
                 2009 => {:math=>0.824, :reading=>0.862, :writing=>0.706 },
                 2010 => {:math=>0.849, :reading=>0.864, :writing=>0.662 },
                 2011 => {:math=>0.819, :reading=>0.867, :writing=>0.678 },
                 2012 => {:math=>0.830, :reading=>0.870, :writing=>0.655 },
                 2013 => {:math=>0.855, :reading=>0.859, :writing=>0.668 },
                 2014 => {:math=>0.834, :reading=>0.831, :writing=>0.639 }
                }

    assert_instance_of StatewideTest, statewide_test
    assert_equal expected, statewide_test.proficient_by_grade(3)
  end

  def test_it_extracts_proficiency_by_grade_data_for_grade_8
    load_data
    statewide_test = str.find_by_name("ACADEMY 20")

    expected = { 2008 => {:math=>0.64, :reading=>0.843, :writing=>0.734  },
                 2009 => {:math=>0.656, :reading=>0.825, :writing=>0.701 },
                 2010 => {:math=>0.672, :reading=>0.863, :writing=>0.754 },
                 2011 => {:math=>0.653, :reading=>0.832, :writing=>0.745 },
                 2012 => {:math=>0.681, :reading=>0.833, :writing=>0.738 },
                 2013 => {:math=>0.661, :reading=>0.852, :writing=>0.75  },
                 2014 => {:math=>0.684, :reading=>0.827, :writing=>0.747 }
                }

    assert_equal expected, statewide_test.proficient_by_grade(8)
  end

  def test_it_raises_error_when_proficient_by_grade_data_is_given_bad_input
    load_data
    statewide_test = str.find_by_name("ADAMS COUNTY 14")

    assert_raises(UnknownDataError) do
      statewide_test.proficient_by_grade(11)
    end
  end

  def test_it_extracts_proficiency_by_race_or_ethnicity_data
    load_data
    statewide_test = str.find_by_name("ACADEMY 20")

    expected =  { 2011 => {math: 0.816, reading: 0.897, writing: 0.826},
                 2012 => {math: 0.818, reading: 0.893, writing: 0.808},
                 2013 => {math: 0.805, reading: 0.901, writing: 0.810},
                 2014 => {math: 0.800, reading: 0.855, writing: 0.789},
                }

    actual = statewide_test.proficient_by_race_or_ethnicity(:asian)
    assert_equal expected, actual
  end

  def test_it_raises_error_when_proficient_by_race_is_given_bad_input
    load_data
    statewide_test = str.find_by_name("ADAMS COUNTY 14")

    assert_raises(UnknownRaceError) do
      statewide_test.proficient_by_race_or_ethnicity(:dragon)
    end
  end

  def test_it_extracts_proficiency_for_subject_in_grade_3
    load_data
    statewide_test = str.find_by_name("ACADEMY 20")

    actual = statewide_test.proficient_for_subject_by_grade_in_year(:math, 3, 2008)
    assert_equal 0.857, actual
  end

  def test_it_extracts_proficiency_for_subject_in_grade_8
    load_data
    statewide_test = str.find_by_name("ACADEMY 20")

    actual = statewide_test.proficient_for_subject_by_grade_in_year(:math, 8, 2008)
    assert_equal 0.64, actual
  end

  def test_it_return_not_applicable_if_the_value_does_not_exist
    load_data
    statewide_test = str.find_by_name("PLATEAU VALLEY 50")

    actual = statewide_test.proficient_for_subject_by_grade_in_year(:reading, 8, 2011)
    assert_equal "N/A", actual
  end

  def test_it_raises_error_when_subject_is_not_included
    load_data
    statewide_test = str.find_by_name("ADAMS COUNTY 14")

    assert_raises(UnknownDataError) do
      statewide_test.proficient_for_subject_by_grade_in_year(:biology, 3, 2008)
    end
  end

  def test_proficiency_for_subject_by_race_in_each_year
    load_data
    statewide_test = str.find_by_name("ACADEMY 20")

    actual = statewide_test.proficient_for_subject_by_race_in_year(:math, :asian, 2012)
    assert_equal 0.818, actual
  end

  def test_it_raises_error_when_subject_by_race_in_each_year_is_invalid
    load_data
    statewide_test = str.find_by_name("ADAMS COUNTY 14")

    assert_raises(UnknownDataError) do
      actual = statewide_test.proficient_for_subject_by_race_in_year(:history, :asian, 2012)
    end
  end

  def test_it_raises_error_when_race_for_subject_by_race_in_each_year_is_invalid
    load_data
    statewide_test = str.find_by_name("ADAMS COUNTY 14")

    assert_raises(UnknownDataError) do
      actual = statewide_test.proficient_for_subject_by_race_in_year(:math, :taco, 2012)
    end
  end
end
