require_relative 'test_helper'
require_relative '../lib/headcount_analyst'


class HeadcountAnalystTest < Minitest::Test
  attr_reader :dr
  def load_data
    @dr = DistrictRepository.new
    @dr.load_data({
                    :enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv",
                    :high_school_graduation => "./data/High school graduation rates.csv"
                    }
                  })
  end

  def load_data_with_statewide_tests
    @dr = DistrictRepository.new
    @dr.load_data({
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
  end

  def test_it_calculates_kindergarten_participation_variation_between_district_and_state
    load_data
    ha = HeadcountAnalyst.new(dr)

    actual = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')

    assert_equal 0.766, actual
  end

  def test_it_calculates_kindergarten_participation_variation_between_districts
    load_data
    ha = HeadcountAnalyst.new(dr)
    actual = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1')

    assert_in_delta 0.447, actual, 0.005
  end

  def test_it_calculates_kindergarten_participation_variation_trend_against_state
    load_data
    ha = HeadcountAnalyst.new(dr)

    actual = ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')

    assert actual
  end

  def test_it_calculates_variance_between_kindergarten_participation_and_high_school_graduation
    load_data
    ha = HeadcountAnalyst.new(dr)

    actual = ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20')
    assert_equal 0.64, actual
  end

  def test_it_calculates_correlation_between_kindergarten_participation_and_high_school_graduation
    load_data
    ha = HeadcountAnalyst.new(dr)

    actual = ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
    assert_equal true, actual
  end

  def test_it_calculates_correlation_between_statewide_kindergarten_participation_and_high_school_graduation
    load_data
    ha = HeadcountAnalyst.new(dr)

    actual = ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'STATEWIDE')

    refute actual
  end

  def test_it_calculates_kindergarten_participation_and_high_school_graduation_correlations_across_districts
    load_data
    ha = HeadcountAnalyst.new(dr)

    actual = ha.kindergarten_participation_correlates_with_high_school_graduation(
                                :across => ['ACADEMY 20', 'ADAMS COUNTY 14', 'AGATE 300', 'AKRON R-1'])
    refute actual
  end

  def test_it_calculates_top_statewide_growth_single_leader
    load_data_with_statewide_tests
    ha = HeadcountAnalyst.new(dr)

    actual = ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
    assert_equal "WILEY RE-13 JT", actual.first
    assert_equal "COTOPAXI RE-3", ha.top_statewide_test_year_over_year_growth(grade: 8, subject: :reading).first
    assert_in_delta 0.13, ha.top_statewide_test_year_over_year_growth(grade: 8, subject: :reading).last, 0.005
    assert_equal "BETHUNE R-5", ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :writing).first
    assert_in_delta 0.148, ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :writing).last, 0.005
  end

  def test_it_calculates_top_statewide_growth_multiple_leaders
    load_data_with_statewide_tests

    ha = HeadcountAnalyst.new(dr)

    expected = [["WILEY RE-13 JT", 0.3], ["SANGRE DE CRISTO RE-22J", 0.071], ["COTOPAXI RE-3", 0.07]]
    actual = ha.top_statewide_test_year_over_year_growth(grade: 3, top:3, subject: :math)

    assert_equal expected, actual
  end

  def test_it_calculates_top_statewide_growth_across_all_subjects
    load_data_with_statewide_tests

    ha = HeadcountAnalyst.new(dr)

    actual = ha.top_statewide_test_year_over_year_growth(grade: 3)

    assert_equal "SANGRE DE CRISTO RE-22J", actual.first
  end

  def test_it_calculates_top_statewide_growth_across_all_subjects_weighted
    load_data_with_statewide_tests

    ha = HeadcountAnalyst.new(dr)

    actual = ha.top_statewide_test_year_over_year_growth(grade: 8,
    :weighting => {:math => 0.5, :reading => 0.5, :writing => 0.0})

    assert_equal "OURAY R-1", actual.first
    assert_equal 0.154, actual.last
  end

  def test_it_raises_error_if_grade_is_not_equal_to_3_or_8
    load_data_with_statewide_tests
    ha = HeadcountAnalyst.new(dr)

     assert_raises(InsufficientInformationError.new.message) do
      ha.top_statewide_test_year_over_year_growth(subject: :math)
     end
  end
  def test_it_raises_error_if_grade_is_not_equal_to_3_or_8
    load_data_with_statewide_tests
    ha = HeadcountAnalyst.new(dr)
    grade = 10

    assert_raises(UnknownDataError.new.message(grade)) do
      ha.top_statewide_test_year_over_year_growth(grade: 10, subject: :math)
    end
  end
end
