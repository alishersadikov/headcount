require_relative 'test_helper'
require_relative '../lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test

  def test_it_loads_repository
    er = EnrollmentRepository.new

    assert er.repo.empty?

    er.load_data( {
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
                     }
                  }
                )
    refute er.repo.empty?
  end

  def test_it_finds_by_district_name
    er = EnrollmentRepository.new
    er.load_data( {
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
                     }
                  }
                )
    enrollment = er.find_by_name("ACADEMY 20")

    assert_equal "ACADEMY 20", enrollment.name
  end
  def test_it_finds_by_partial_district_name
    er = EnrollmentRepository.new
    er.load_data( {
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
                     }
                  }
                )
    enrollment = er.find_by_name("Colorado")

    assert_equal "COLORADO", enrollment.name
  end



  def test_it_finds_kindergarten_participation_by_year
    er = EnrollmentRepository.new
    er.load_data( {
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
                     }
                  }
                )
    enrollment = er.find_by_name("ACADEMY 20")

    result = ( { 2004=>0.302, 2005=>0.267, 2006=>0.353,
                2007=>0.391, 2008=>0.384, 2009=>0.39,
                2010=>0.436, 2011=>0.489, 2012=>0.478,
                2013=>0.487, 2014=>0.490 } )


    assert_instance_of Enrollment, enrollment
    assert_equal result, enrollment.kindergarten_participation_by_year
  end
  def test_it_finds_kindergarten_participation_by_year_with_snippet
    er = EnrollmentRepository.new
    er.load_data( {
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
                     }
                  }
                )
    enrollment = er.find_by_name("WE")

    assert_instance_of Enrollment, enrollment
    assert_equal result, enrollment.kindergarten_participation_by_year
  end
  def test_it_finds_kindergarten_participation_by_year
    er = EnrollmentRepository.new
    er.load_data( {
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
                     }
                  }
                )
    enrollment = er.find_by_name("ACADEMY 20")

    result = ( { 2004=>0.302, 2005=>0.267, 2006=>0.353,
                2007=>0.391, 2008=>0.384, 2009=>0.39,
                2010=>0.436, 2011=>0.489, 2012=>0.478,
                2013=>0.487, 2014=>0.490 } )


    assert_instance_of Enrollment, enrollment
    assert_equal 0.436, enrollment.kindergarten_participation_in_year(2010)
    assert_equal nil, enrollment.kindergarten_participation_in_year(2222)
  end
end
