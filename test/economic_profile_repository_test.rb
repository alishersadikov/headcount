require_relative 'test_helper'
require_relative '../lib/economic_profile_repository'

class EconomicProfileRepositoryTest < Minitest::Test
  attr_reader :epr

  def setup
    @epr = EconomicProfileRepository.new
  end

  def load_data
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
                            }
                   })
  end

  def test_it_loads_economic_profile_data
    assert_equal ({}), epr.economic_profiles

    load_data

    refute_equal ({}), epr.economic_profiles
  end

  def test_it_finds_by_name
    load_data
    ep = epr.find_by_name("ACADEMY 20")

    assert_equal "ACADEMY 20", ep.name
  end

  def test_it_parses_median_household_income_data_correctly
    load_data
    ep = epr.find_by_name("ACADEMY 20")

    expected = {[2005, 2009]=>85060.0, [2006, 2010]=>85450.0,
                [2008, 2012]=>89615.0, [2007, 2011]=>88099.0, [2009, 2013]=>89953.0}

    assert_equal expected, ep.median_household_income
  end

  def test_it_parses_children_in_poverty_data_correctly
    load_data
    ep = epr.find_by_name("ACADEMY 20")

    expected = {1995=>0.032, 1997=>0.035, 1999=>0.032, 2000=>0.031, 2001=>0.029,
                2002=>0.033, 2003=>0.037, 2004=>0.034, 2005=>0.042, 2006=>0.036,
                2007=>0.039, 2008=>855.0, 2009=>0.047, 2010=>0.057, 2011=>0.059,
                2012=>0.064, 2013=>0.048}

    assert_equal expected, ep.children_in_poverty
  end

  def test_it_parses_free_or_reduced_lunch_data_correctly
    load_data
    ep = epr.find_by_name("ACADEMY 20")

    expected = {2014=>{:total=>3132, :percentage=>0.127}, 2012=>{:percentage=>0.125, :total=>3006},
                2011=>{:total=>2834, :percentage=>0.119}, 2010=>{:percentage=>0.113, :total=>2601},
                2009=>{:total=>2338, :percentage=>0.103}, 2013=>{:percentage=>0.131, :total=>3225},
                2008=>{:total=>2058, :percentage=>0.093}, 2007=>{:percentage=>0.08, :total=>1630},
                2006=>{:total=>1534, :percentage=>0.072}, 2005=>{:percentage=>0.058, :total=>1204},
                2004=>{:total=>1182, :percentage=>0.059}, 2003=>{:percentage=>0.06, :total=>1062},
                2002=>{:total=>905, :percentage=>0.048}, 2001=>{:percentage=>0.047, :total=>855},
                2000=>{:total=>701, :percentage=>0.04}}

    assert_equal expected, ep.free_or_reduced_price_lunch
  end

  def test_it_parses_title_i_data_correctly
    load_data
    ep = epr.find_by_name("ACADEMY 20")

    expected = {2009=>0.014, 2011=>0.011, 2012=>0.01, 2013=>0.012, 2014=>0.027}

    assert_equal expected, ep.title_i
  end
end
