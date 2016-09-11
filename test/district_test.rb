require './test/test_helper'
require './lib/district'

class DistrictTest < Minitest::Test

  def test_name_returns_upcased_string
    d = District.new({:name => "Colorado"})

    assert_equal "COLORADO", d.name
  end
end
