require_relative 'test_helper'
require 'csv'
require_relative '../lib/statewide_test'
require_relative '../lib/statewide_test_repository'

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

  def test_it_stores_and_extracts_name_for_statewidetest_object
    str = StatewideTest.new(name: "Adams County 14")
    assert_equal "ADAMS COUNTY 14", str.name
  end

  def test_all_attribtues_are_empty_hashes_if_no_data_given
    str = StatewideTest.new(name: "Adams County 14")

    assert_equal ({}), str.third_grade
    assert_equal ({}), str.eighth_grade
    assert_equal ({}), str.math
    assert_equal ({}), str.reading
    assert_equal ({}), str.writing
  end

  def test_it_stores_and_extracts_third_grade_data
    data = { 2008=>{:math=>0.56,  :reading=>0.523, :writing=>0.426},
             2009=>{:math=>0.54,  :reading=>0.562, :writing=>0.479},
             2010=>{:math=>0.469, :reading=>0.457, :writing=>0.312},
             2011=>{:math=>0.476, :reading=>0.571, :writing=>0.31},
             2012=>{:math=>0.39,  :reading=>0.54,  :writing=>0.287},
             2013=>{:math=>0.437, :reading=>0.548, :writing=>0.283},
             2014=>{:math=>0.512, :reading=>0.476, :writing=>0.274} }

    str = StatewideTest.new(name: "Adams County 14", third_grade: data)

    assert_equal data, str.third_grade
  end

  def test_it_stores_and_extracts_eighth_grade_data
    data = { 2008=>{:math=>0.22,  :reading=>0.426, :writing=>0.444},
             2009=>{:math=>0.3,   :reading=>0.398, :writing=>0.471},
             2010=>{:math=>0.42,  :reading=>0.514, :writing=>0.376},
             2011=>{:math=>0.377, :reading=>0.487, :writing=>0.33},
             2012=>{:math=>0.298, :reading=>0.328, :writing=>0.28},
             2013=>{:math=>0.306, :reading=>0.447, :writing=>0.381},
             2014=>{:math=>0.296, :reading=>0.421, :writing=>0.357} }

    str = StatewideTest.new(name: "Adams County 14", eighth_grade: data)

    assert_equal data, str.eighth_grade
  end

  def test_it_stores_and_extracts_eighth_math_data
    data = {2011=>{:all_students=>0.32, :asian=>0.0, :black=>0.196, :pacific_islander=>0.0,
                    :hispanic=>0.315, :native_american=>0.312, :two_or_more=>0.333, :white=>0.381},
            2012=>{:all_students=>0.287, :asian=>0.0, :black=>0.225, :pacific_islander=>0.307,
                    :hispanic=>0.28, :native_american=>0.307, :two_or_more=>0.347, :white=>0.333}}

    str = StatewideTest.new(name: "Adams County 14", math: data)

    assert_equal data, str.math
  end

  def test_it_stores_and_extracts_eighth_reading_data
    data = {2011=>{:all_students=>0.44, :asian=>0.0, :black=>0.333, :pacific_islander=>0.0,
                    :hispanic=>0.434, :native_american=>0.484, :two_or_more=>0.458, :white=>0.522},
            2012=>{:all_students=>0.426, :asian=>0.0, :black=>0.324, :pacific_islander=>0.0,
                    :hispanic=>0.418, :native_american=>0.538, :two_or_more=>0.478, :white=>0.485}}

    str = StatewideTest.new(name: "Adams County 14", reading: data)

    assert_equal data, str.reading
  end

  def test_it_stores_and_extracts_eighth_writing_data
    data = {2011=>{:all_students=>0.317, :asian=>0.0, :black=>0.225, :pacific_islander=>0.0,
                    :hispanic=>0.311, :native_american=>0.363, :two_or_more=>0.5, :white=>0.346},
            2012=>{:all_students=>0.279, :asian=>0.0, :black=>0.216, :pacific_islander=>0.0,
                    :hispanic=>0.279, :native_american=>0.346, :two_or_more=>0.434, :white=>0.276}}

    str = StatewideTest.new(name: "Adams County 14", writing: data)

    assert_equal data, str.writing
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

    expected = { 2008 => {:math=>0.64,  :reading=>0.843, :writing=>0.734  },
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
      statewide_test.proficient_for_subject_by_race_in_year(:history, :asian, 2012)
    end
  end

  def test_it_raises_error_when_race_for_subject_by_race_in_each_year_is_invalid
    load_data
    statewide_test = str.find_by_name("ADAMS COUNTY 14")

    assert_raises(UnknownDataError) do
      statewide_test.proficient_for_subject_by_race_in_year(:math, :taco, 2012)
    end
  end
end
