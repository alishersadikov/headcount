class Statewidetest
  attr_reader :third_grade,
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
end
