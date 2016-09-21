require_relative "../lib/district_repository"
require_relative '../lib/cleaner'
require_relative '../lib/errors'

class HeadcountAnalyst
  attr_reader :district_repo
  include Cleaner

  GRADES   = [3, 8]

  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(district_1, district_2)
    district_1_average = calculate_average(district_1, "kindergarten")
    district_2_average = calculate_average(district_2[:against], "kindergarten")
    truncate_number(district_1_average / district_2_average)
  end

  def kindergarten_participation_rate_variation_trend(district_1, district_2)
    district_1_data = extract_data(district_1, "kindergarten")
    district_2_data = extract_data(district_2[:against], "kindergarten")
    keys = district_1_data.keys
    zipped = district_1_data.values.zip(district_2_data.values)
    quotients = calculate_quotients_for_kindergarten(zipped)
    keys.zip(quotients).to_h
  end

  def kindergarten_participation_against_high_school_graduation(district_name)
    kindergarten_var = kindergarten_participation_rate_variation(
                                      district_name, :against => "COLORADO")
    district_average = calculate_average(
                                      district_name, "graduation_rate_by_year")
    state_average = calculate_average("COLORADO", "graduation_rate_by_year")
    graduation_var = district_average / state_average
    check_for_zero(graduation_var, kindergarten_var)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(param)
    district_name = param[:for]
    calculate_different_correlations(district_name, param)
  end

  def top_statewide_test_year_over_year_growth(input_hash)
    grade = input_hash[:grade]
    raise InsufficientInformationError if grade.nil?
    raise UnknownDataError.new.message unless GRADES.include?(grade)
    subject = input_hash[:subject] if !input_hash[:subject].nil?
    return top_statewide_all_subjects(input_hash) if input_hash[:subject].nil?
    sorted_grades = build_grades_repo_and_sort(subject, grade)
    one_leader_or_many?(input_hash, sorted_grades)
  end

  private

  def calculate_quotients_for_kindergarten(zipped_data)
    zipped_data.map do |data_pair|
      (truncate_number(data_pair[0]/data_pair[1]))
    end
  end

  def check_for_zero(graduation_var, kindergarten_var)
    graduation_var == 0 ? 0 : truncate_number(kindergarten_var/graduation_var)
  end

  def calculate_different_correlations(district_name, parameter)
    if district_repo.find_by_name(district_name)
      kindergarten_participation_against_high_school_graduation(
      district_name).between?(0.6, 1.5)
    elsif district_name == "STATEWIDE"
      calculate_statewide_correlation
    elsif parameter[:across]
      correlation_across_multiple_districts(parameter[:across])
    end
  end

  def one_leader_or_many?(input_hash, sorted_grades)
    return sorted_grades.first if input_hash[:top].nil?
    return sorted_grades[0..input_hash[:top]-1]
  end

  def build_grades_repo_and_sort(subject, grade)
    grades = district_repo.statewidetests.statewidetests.map { |name, district|
      [name, calculate_year_over_year_growth(district, subject, grade)] }
    grades.sort_by { |district|  district[1] }.reverse
  end

  def top_statewide_all_subjects(input_hash)
    average_growth_data = compute_subject_leaders(input_hash)
    average_growth_data.sort_by { |district|  district.last }.last
  end

  def determine_individual_weights(input_hash)
    input = input_hash[:weighting]
    input.nil? ? weight_1 = 1 : weight_1 = input[:math] * 3
    input.nil? ? weight_2 = 1 : weight_2 = input[:reading] * 3
    input.nil? ? weight_3 = 1 : weight_3 = input[:writing] * 3
    [weight_1, weight_2, weight_3]
  end

  def compute_subject_leaders(input_hash)
    subjects = [:math, :reading, :writing]
    subject_leaders = subjects.map do |subject|
      top_statewide_test_year_over_year_growth(
      grade: input_hash[:grade], top: 0, subject: subject)
    end
    weights = determine_individual_weights(input_hash)
    group_subject_leaders(subject_leaders, weights)
  end

  def group_subject_leaders(subject_leaders, weights)
    sorted_leaders = subject_leaders.map { |leader| leader.sort }
    names = sorted_leaders.first.map { |leader|  leader.first }
    math_data = build_subject_data(sorted_leaders[0])
    reading_data = build_subject_data(sorted_leaders[1])
    writing_data = build_subject_data(sorted_leaders[2])
    zipped_data = math_data.zip(reading_data, writing_data)
    calculate_average_growth(names, zipped_data, weights)
  end

  def calculate_average_growth(names, zipped_data, weights)
    averages = zipped_data.map do |data|
      ((data[0] * weights[0] + data[1] *  weights[1] +
      data[2] * weights[2])/data.size).round(3)
    end
    names.zip(averages)
  end

  def build_subject_data(leader)
    leader.map { |district|  district.last }
  end

  def calculate_year_over_year_growth(swt, subject, grade)
    first_value = get_the_earliest_value(swt, subject, grade)[0]
    last_value  = get_the_latest_value(swt, subject, grade)[0]
    first_year  = get_the_earliest_value(swt, subject, grade)[1]
    last_year   = get_the_latest_value(swt, subject, grade)[1]
    zero_year_difference?(first_value, last_value, first_year, last_year)
  end

  def zero_year_difference?(first_value, last_value, first_year, last_year)
    if (last_year - first_year) != 0.0
      truncate_number((last_value - first_value) / (last_year - first_year))
    else
      truncate_number(last_value - first_value)
    end
  end

  def get_the_earliest_value(swt, subject, grade)
    first_year = 2007
    first = 0.0
    until first != 0.0
      first_year += 1
      first = swt.proficient_for_subject_by_grade_in_year(
                                            subject, grade, first_year).to_f
      break if first_year == 2014
    end
    [first, first_year]
  end

  def get_the_latest_value(swt, subject, grade)
    last_year = 2015
    last = 0.0
    until last != 0.0
      last_year -= 1
      last = swt.proficient_for_subject_by_grade_in_year(
                                            subject, grade, last_year).to_f
      break if last_year == 2008
    end
    [last, last_year]
  end

  def correlation_across_multiple_districts(districts)
    district_correlations = districts.map do |district|
      kindergarten_participation_correlates_with_high_school_graduation(
                                                              for: district)
    end
    district_correlations.count(true).to_f / district_correlations.count > 0.70
  end

  def calculate_statewide_correlation
    district_correlations = district_repo.districts.map do |name, district|
      kindergarten_participation_correlates_with_high_school_graduation(
                                                                  for: name)
    end
    district_correlations.count(true).to_f / district_correlations.count > 0.70
  end

  def calculate_average(district_name, attribute)
    data = extract_data(district_name, attribute).values
    average = data.inject(:+)/data.size
    truncate_number(average)
  end

  def extract_data(district_name, attribute)
    district_repo.enrollments.find_by_name(district_name).send(attribute)
  end
end
