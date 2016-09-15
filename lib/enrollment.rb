class Enrollment
  attr_reader :name,
              :kindergarten,
              :high_school_graduation

  def initialize(enrollment_data)
    @name = enrollment_data[:name].upcase
    @kindergarten = enrollment_data[:kindergarten] || {}
    @high_school_graduation = enrollment_data[:high_school_graduation] || {}
  end

  def kindergarten_participation_by_year
    kindergarten
  end

  def kindergarten_participation_in_year(year)
    kindergarten[year]
  end

  def graduation_rate_by_year

  end
end
