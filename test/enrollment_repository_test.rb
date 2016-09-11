require './test/test_helper'
require './lib/enrollment_repository'

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

  def test_it_finds_by_name
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

  def test_it_finds_by_name
    er = EnrollmentRepository.new
    er.load_data( {
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
                     }
                  }
                )
    enrollment = er.find_by_name("ACADEMY 20")

    result = ( {2004=>0.30201, 2005=>0.26709, 2006=>0.35364,
                2007=>0.39159, 2008=>0.38456, 2009=>0.39,
                2010=>0.43628, 2011=>0.489, 2012=>0.47883,
                2013=>0.48774, 2014=>0.49022 } )

    assert_equal result, enrollment.kindergarten_participation_by_year
  end
end
# Example:
#
# enrollment.kindergarten_participation_by_year
# => { 2010 => 0.391,
#      2011 => 0.353,
#      2012 => 0.267,
#    }
# .kindergarten_participation_in_year(year)
#
# This method takes one parameter:
#
# year as an integer for any year reported in the data
# A call to this method with any unknown year should return nil.
#
# The method returns a truncated three-digit floating point number representing a percentage.
#
# Example:
#
# enrollment.kindergarten_participation_in_year(2010) # => 0.391
