require_relative 'test_helper'
require_relative '../lib/headcount_analyst'

class HeadcountAnalystTest < Minitest::Test
  attr_reader :dr

  def setup
    @dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)
  end

  def dr
    @dr
  end

  def test_it_calculates_kindergarten_participation_variation_between_district_and_state

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

    expected = { 2004 => 1.258, 2005 => 0.96, 2006 => 1.05,
                 2007 => 0.992, 2008 => 0.717, 2009 => 0.652,
                 2010 => 0.681, 2011 => 0.727, 2012 => 0.687,
                 2013 => 0.693, 2014 => 0.661 }

    actual = ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')

    assert_equal expected, actual
  end

  # account for an edge case where non-existent district_name is given
end
