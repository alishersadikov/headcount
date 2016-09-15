class District
  attr_reader   :name,
                :district_repo

  def initialize(district_data, district_repo = 0)
    @name = district_data[:name].upcase
    @district_repo = district_repo
  end

  def enrollment
    district_repo.link_enrollments_to_districts(name)
  end

end
