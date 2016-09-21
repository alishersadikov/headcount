require_relative "test_helper"
require_relative "../lib/enrollment"
require_relative "../lib/enrollment_repository"

class EnrollmentTest < Minitest::Test
  attr_reader :er

  def setup
    @er = EnrollmentRepository.new
  end

  def load_data
    er.load_data({
                  :enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv",
                    :high_school_graduation => "./data/High school graduation rates.csv",
                                  }

                  })
  end

  def test_it_stores_and_extracts_name_for_enrollment_object

    e = Enrollment.new( { :name => "ACADEMY 20",
                            :kindergarten => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677 },
                            :high_school_graduation => {2010=>0.895, 2011=>0.895, 2012=>0.889, 2013=>0.913, 2014=>0.898}
                         }
                       )

   assert_equal "ACADEMY 20", e.name
  end

  def test_it_stores_and_extracts_kindergarten_data

    e = Enrollment.new( { :name => "ACADEMY 20",
                            :kindergarten => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677 },
                            :high_school_graduation => {2010=>0.895, 2011=>0.895, 2012=>0.889, 2013=>0.913, 2014=>0.898}
                         }
                       )

   result = ( { 2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677 } )

   assert_equal result, e.kindergarten
  end

  def test_it_stores_and_extracts_high_school_graduation_data

    e = Enrollment.new( { :name => "ACADEMY 20",
                            :kindergarten => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677 },
                            :high_school_graduation => {2010=>0.895, 2011=>0.895, 2012=>0.889, 2013=>0.913, 2014=>0.898}
                         }
                       )

   result = ( {2010=>0.895, 2011=>0.895, 2012=>0.889, 2013=>0.913, 2014=>0.898} )

   assert_equal result, e.high_school_graduation
  end

  def test_it_extracts_kindergarten_participation_by_year
    load_data
    enrollment = er.find_by_name("ACADEMY 20")

    result = ( { 2004=>0.302, 2005=>0.267, 2006=>0.353,
                 2007=>0.391, 2008=>0.384, 2009=>0.39,
                 2010=>0.436, 2011=>0.489, 2012=>0.478,
                 2013=>0.487, 2014=>0.490 } )

    assert_instance_of Enrollment, enrollment
    assert_equal result, enrollment.kindergarten_participation_by_year
  end

  def test_it_extracts_kindergarten_participation_in_year
    load_data
    enrollment = er.find_by_name("ACADEMY 20")

    assert_instance_of Enrollment, enrollment
    assert_equal 0.436, enrollment.kindergarten_participation_in_year(2010)
    assert_equal 0.490, enrollment.kindergarten_participation_in_year(2014)
  end

  def test_kindergarten_participation_in_year_returns_nil_for_invalid_year
    load_data
    enrollment = er.find_by_name("ACADEMY 20")

    assert_instance_of Enrollment, enrollment
    assert_equal nil, enrollment.kindergarten_participation_in_year(2000)
    assert_equal nil, enrollment.kindergarten_participation_in_year(2016)
  end

  def test_it_extracts_high_school_graduation_data_by_year
    load_data
    enrollment = er.find_by_name("ACADEMY 20")

    expected = { 2010 => 0.895,
                 2011 => 0.895,
                 2012 => 0.889,
                 2013 => 0.913,
                 2014 => 0.898 }

    assert_equal expected, enrollment.graduation_rate_by_year
  end

  def test_it_extracts_high_school_gradutation_data_in_year
    load_data
    enrollment = er.find_by_name("ACADEMY 20")

    assert_equal 0.895, enrollment.graduation_rate_in_year(2010)
  end
end
