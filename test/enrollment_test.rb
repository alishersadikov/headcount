require_relative "test_helper"
require_relative "../lib/enrollment"
require_relative "../lib/enrollment_repository"

class EnrollmentTest < Minitest::Test

  def test_it_instantiates_enrollment_with_name_and_kindergarten_participation
    e = Enrollment.new( { :name => "ACADEMY 20",
                          :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677 }
                        }
                      )

   result = ( { 2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677 } )

   assert_equal "ACADEMY 20", e.name
   assert_equal result, e.kindergarten_participation
  end

  def test_it_instantiates_enrollment_with_name_and_kindergarten_participation
    er = EnrollmentRepository.new

    er.load_data({
                    :enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv",
                    :high_school_graduation => "./data/High school graduation rates.csv"
                    }
                  })

    enrollment = er.find_by_name("ACADEMY 20")
    expected = { 2010 => 0.895,
                2011 => 0.895,
                2012 => 0.889,
                2013 => 0.913,
                2014 => 0.898,
              }

    assert_equal expected, enrollment.graduation_rate_by_year

  end

end
