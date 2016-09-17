class Statewidetest
  attr_accessor :name,
                :third_grade,
                :eighth_grade,
                :math,
                :reading,
                :writing

  def initialize(statewidetest_data)
    binding.pry
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
    empty = {}
    math.each {|key, value| empty.store(key, {:math=>value[race]})}
    # {2011=>{:math=>0.816}, 2012=>{:math=>nil}, 2013=>{:math=>0.805}, 2014=>{:math=>0.8}}
    reading.each {|key, value| empty.store(key, {:reading=>value[race]})}
    # {2011=>{:reading=>0.897}, 2012=>{:reading=>0.893}, 2013=>{:reading=>0.901}, 2014=>{:reading=>0.855}}
    writing.each {|key, value| empty.store(key, {:writing=>value[race]})}
    empty = {}
    math.map { |key,value| empty.store(key, {:math=>value[race]})}

  end

end
