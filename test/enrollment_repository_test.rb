require_relative 'test_helper'
require_relative '../lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test
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

  def test_it_loads_repository
    assert er.enrollments.empty?

    load_data

    refute er.enrollments.empty?
  end

  def test_it_finds_by_district_name
    load_data

    enrollment = er.find_by_name("ACADEMY 20")

    assert_equal "ACADEMY 20", enrollment.name
  end

  def test_it_loads_and_extracts_kindergarten_data
    load_data

    enrollment = er.find_by_name("ADAMS COUNTY 14")

    expected = {2007=>0.306, 2006=>0.293, 2005=>0.3, 2004=>0.227, 2008=>0.673,
                2009=>1.0, 2010=>1.0, 2011=>1.0, 2012=>1.0, 2013=>0.998, 2014=>1.0}

    assert_equal expected, enrollment.kindergarten
  end

  def test_it_loads_and_extracts_kindergarten_data
    load_data

    enrollment = er.find_by_name("ADAMS COUNTY 14")

    expected = {2010=>0.57, 2011=>0.608, 2012=>0.633, 2013=>0.593, 2014=>0.659}

    assert_equal expected, enrollment.high_school_graduation
  end
end
