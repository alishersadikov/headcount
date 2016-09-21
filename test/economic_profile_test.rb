require_relative 'test_helper'
require_relative '../lib/economic_profile'

class EconomicProfileTest < Minitest::Test
    attr_reader :economic_profile

    def setup
      @economic_profile = EconomicProfile.new(data)
    end

    def data
      { :median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }
    end

    def test_all_attribtues_except_for_name_are_empty_hashes_if_no_data_given
      economic_profile = EconomicProfile.new( { :name => "ACADEMY 20" } )

      assert_equal "ACADEMY 20", economic_profile.name
      assert_equal ({}), economic_profile.median_household_income
      assert_equal ({}), economic_profile.children_in_poverty
      assert_equal ({}), economic_profile.free_or_reduced_price_lunch
      assert_equal ({}), economic_profile.title_i
    end

    def test_it_loads_name_correctly
      assert_equal "ACADEMY 20", economic_profile.name
    end

    def test_it_loads_median_household_income_correctly
      expected = {[2005, 2009]=>50000, [2008, 2014]=>60000}
      assert_equal expected, economic_profile.median_household_income
    end

    def test_it_loads_children_in_poverty_correctly
      expected = {2012=>0.1845}
      assert_equal expected, economic_profile.children_in_poverty
    end

    def test_it_loads_free_or_reduced_price_lunch_correctly
      expected = {2014=>{:percentage=>0.023, :total=>100}}
      assert_equal expected, economic_profile.free_or_reduced_price_lunch
    end

    def test_it_loads_title_i_correctly
      expected = {2015=>0.543}
      assert_equal expected, economic_profile.title_i
    end

    def test_it_calculates_median_household_income_in_year_single_occurence
      actual = economic_profile.median_household_income_in_year(2005)
      assert_equal 50000, actual
    end

    def test_it_calculates_median_household_income_in_year_double_occurence
      actual = economic_profile.median_household_income_in_year(2009)
      assert_equal 55000, actual
    end

    def test_median_household_income_in_year_raises_error_if_year_invalid
      assert_raises(UnknownDataError) do
        economic_profile.median_household_income_in_year(2016)
      end
    end

    def test_it_calculates_median_household_income_average
      actual = economic_profile.median_household_income_average
      assert_equal 55000, actual
    end

    def test_it_extracts_children_in_poverty_in_year
      actual = economic_profile.children_in_poverty_in_year(2012)
      assert_equal 0.184, actual
    end

    def test_children_in_poverty_in_year_raises_error_if_year_invalid
      assert_raises(UnknownDataError) do
        economic_profile.children_in_poverty_in_year(2016)
      end
    end

    def test_it_extracts_free_or_reduced_price_lunch_percentage_in_year
      actual = economic_profile.free_or_reduced_price_lunch_percentage_in_year(2014)
      assert_equal 0.023, actual
    end

    def test_it_extracts_free_or_reduced_price_lunch_number_in_year
      actual = economic_profile.free_or_reduced_price_lunch_number_in_year(2014)
      assert_equal 100, actual
    end

    def test_free_or_reduced_price_lunch_percentage_in_year_raises_error_if_year_invalid
      assert_raises(UnknownDataError) do
        economic_profile.free_or_reduced_price_lunch_percentage_in_year(2016)
      end
    end

    def test_free_or_reduced_price_lunch_number_in_year_raises_error_if_year_invalid
      assert_raises(UnknownDataError) do
        economic_profile.free_or_reduced_price_lunch_number_in_year(2016)
      end
    end

    def test_it_extracts_title_i_data_in_year
      actual = economic_profile.title_i_in_year(2015)
      assert_equal 0.543, actual
    end

    def test_title_i_data_in_year_raises_error_if_year_invalid
      assert_raises(UnknownDataError) do
        economic_profile.title_i_in_year(2016)
      end
    end
end
