require_relative '../lib/errors'

class StatewideTest

  GRADES   = [3, 8]
  SUBJECTS = [:math, :reading, :writing]
  RACES    =  [:asian, :black, :pacific_islander,
               :hispanic, :native_american, :two_or_more, :white]

  attr_reader   :name,
                :third_grade,
                :eighth_grade,
                :math,
                :reading,
                :writing

  def initialize(statewidetest_data)
    @name = statewidetest_data[:name].upcase
    @third_grade = statewidetest_data[:third_grade] || {}
    @eighth_grade = statewidetest_data[:eighth_grade] || {}
    @math = statewidetest_data[:math] || {}
    @reading = statewidetest_data[:reading] || {}
    @writing = statewidetest_data[:writing] || {}
  end


  def proficient_by_grade(grade)
    raise UnknownDataError unless GRADES.include?(grade)
    return third_grade  if grade == 3
    return eighth_grade if grade == 8
  end

  def proficient_by_race_or_ethnicity(race)
    raise UnknownRaceError unless RACES.include?(race)
    race_hash = {}
    extract_race_data_for_math(race, race_hash)
    extract_race_data_for_reading(race, race_hash)
    extract_race_data_for_writing(race, race_hash)
    race_hash
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
   raise UnknownDataError unless SUBJECTS.include?(subject)
   output = proficient_by_grade(grade)[year][subject]
   output == 0.0 ? "N/A" : output
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    raise UnknownDataError unless SUBJECTS.include?(subject)
    raise UnknownDataError unless RACES.include?(race)
    proficient_by_race_or_ethnicity(race)[year][subject]
  end

  private

  def extract_race_data_for_math(race, race_hash)
    math.each do |year, race_to_score|
      if race_hash[year].nil?
        race_hash[year] = {math: race_to_score[race]}
      else
       race_hash[year].store(:math, race_to_score[race])
      end
    end
  end

  def extract_race_data_for_reading(race, race_hash)
    reading.each do |year, race_to_score|
      if race_hash[year].nil?
        race_hash[year] = {reading: race_to_score[race]}
      else
        race_hash[year].store(:reading, race_to_score[race])
      end
    end
  end

  def extract_race_data_for_writing(race, race_hash)
    writing.each do |year, race_to_score|
      if race_hash[year].nil?
        race_hash[year] = {writing: race_to_score[race]}
      else
        race_hash[year].store(:writing, race_to_score[race])
      end
    end
  end
end
