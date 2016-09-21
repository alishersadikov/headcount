require_relative "test_helper"
require_relative "../lib/cleaner"

class CleanerTest < Minitest::Test
  include Cleaner

  def test_it_truncates_number_to_three_decimal_points
    assert_equal 0.412, truncate_number(0.4123407987)
    assert_equal 1.097, truncate_number(1.09781234)
  end

  def test_it_cleans_symbol_hawaiian_pacific_islander
    assert_equal :pacific_islander, clean_symbol("hawaiian/pacific islander".to_sym)
  end

  def test_it_cleans_other_symbols
    assert_equal :asian, clean_symbol("as`ian".to_sym)
    assert_equal :mar_tian, clean_symbol("mar ti`an".to_sym)
  end

  def test_it_creates_an_array_for_year_range
    assert_equal [2000, 2005], create_array("2000-2005")
    assert_equal [2009, 2014], create_array("2009-2014")
  end
end
