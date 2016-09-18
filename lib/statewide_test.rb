class StatewideTest
  attr_accessor :name,
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
    return third_grade  if grade == 3
    return eighth_grade if grade == 8
    "UnknownDataError" # use raise error
  end

  def proficient_by_race_or_ethnicity(race)
    race_hash = {}
    math.each do |year, race_to_score|
      if race_hash[year].nil?
        race_hash[year] = {math: race_to_score[race]}
      else
       race_hash[year].store(:math, race_to_score[race])
      end
    end

    reading.each do |year, race_to_score|
      if race_hash[year].nil?
        race_hash[year] = {reading: race_to_score[race]}
      else
        race_hash[year].store(:reading, race_to_score[race])
      end
    end

    writing.each do |year, race_to_score|
      if race_hash[year].nil?
        race_hash[year] = {writing: race_to_score[race]}
      else
        race_hash[year].store(:writing, race_to_score[race])
      end
    end
    race_hash
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    proficient_by_grade(grade)[year][subject]
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    proficient_by_race_or_ethnicity(race)[year][subject]
  end
end
