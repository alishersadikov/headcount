require_relative "test_helper"
require_relative "../lib/enrollment"

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
end
