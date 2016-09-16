require_relative 'test_helper'
require_relative '../lib/headcount_analyst'

class HeadcountAnalystTest < Minitest::Test

  def test_it_calculates_kindergarten_participation_variation_between_district_and_state
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)

    actual = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')

    assert_equal 0.766, actual
  end

  def test_it_calculates_kindergarten_participation_variation_between_districts
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})

    ha = HeadcountAnalyst.new(dr)
    actual = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1')

    assert_in_delta 0.447, actual, 0.005
  end

  def test_it_calculates_kindergarten_participation_variation_trend_against_state
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)

    actual = ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')

    assert actual
  end

  def test_it_calculates_variance_between_kindergarten_participation_and_high_school_graduation
    dr = DistrictRepository.new
    # dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    dr.load_data({
                    :enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv",
                    :high_school_graduation => "./data/High school graduation rates.csv"
                    }
                  })

    ha = HeadcountAnalyst.new(dr)

    actual = ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20')
    assert_equal 0.64, actual
  end

  def test_it_calculates_correlation_between_kindergarten_participation_and_high_school_graduation
    dr = DistrictRepository.new
    dr.load_data({
                    :enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv",
                    :high_school_graduation => "./data/High school graduation rates.csv"
                    }
                  })

    ha = HeadcountAnalyst.new(dr)

    actual = ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
    assert_equal true, actual
  end

  def test_it_calculates_correlation_between_statewide_kindergarten_participation_and_high_school_graduation
    dr = DistrictRepository.new
    dr.load_data({
                    :enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv",
                    :high_school_graduation => "./data/High school graduation rates.csv"
                    }
                  })

    ha = HeadcountAnalyst.new(dr)

    actual = ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'STATEWIDE')
    refute actual
  end

  def test_it_calculates_kindergarten_participation_and_high_school_graduation_correlations_across_districts
    dr = DistrictRepository.new
    dr.load_data({
                    :enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv",
                    :high_school_graduation => "./data/High school graduation rates.csv"
                    }
                  })

    ha = HeadcountAnalyst.new(dr)

    actual = ha.kindergarten_participation_correlates_with_high_school_graduation(
                                :across => ['ACADEMY 20', 'ADAMS COUNTY 14', 'AGATE 300', 'AKRON R-1'])
    refute actual
  end

  # account for an edge case where non-existent district_name is given
end
