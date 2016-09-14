class Enrollment
  attr_reader :name, :kindergarten_participation

  def initialize(enrollment_data)
    @name = enrollment_data[:name].upcase
    @kindergarten_participation = enrollment_data[:kindergarten_participation]
  end

  def kindergarten_participation_by_year
    kindergarten_participation
  end

  def kindergarten_participation_in_year(year)
    kindergarten_participation[year]
  end
end
