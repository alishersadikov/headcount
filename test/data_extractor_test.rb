require_relative "test_helper"
require_relative "../lib/data_extractor"

class DataExtractorTest < Minitest::Test
  include DataExtractor

  def test_it_returns_attribute_and_csv_object_for_single_file
    file = {:kindergarten=>"./data/Kindergartners in full-day program.csv"}

    assert_instance_of Array, DataExtractor.extract_data(file)
    assert_instance_of Array, DataExtractor.extract_data(file).first
    assert_equal :kindergarten, DataExtractor.extract_data(file).first.first
    assert_instance_of CSV, DataExtractor.extract_data(file).first.last
  end

  def test_it_returns_attribute_and_csv_object_for_multiple_files
    file = { :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
             :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
             :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
             :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
             :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv" }

    assert_instance_of Array, DataExtractor.extract_data(file)
    assert_equal :third_grade, DataExtractor.extract_data(file)[0][0]
    assert_equal :eighth_grade, DataExtractor.extract_data(file)[1][0]
    assert_equal :math, DataExtractor.extract_data(file)[2][0]
    assert_equal :reading, DataExtractor.extract_data(file)[3][0]
    assert_equal :writing, DataExtractor.extract_data(file)[4][0]
    assert_instance_of CSV, DataExtractor.extract_data(file)[0][1]
    assert_instance_of CSV, DataExtractor.extract_data(file)[4][1]
  end
end
