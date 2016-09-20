class District
  attr_reader   :name,
                :district_repo

  def initialize(district_data, district_repo = nil)
    @name = district_data[:name].upcase
    @district_repo = district_repo
  end

  def enrollment
    district_repo.link_enrollments_to_districts(name)
  end

  def statewide_test
    district_repo.link_statewidetests_to_districts(name)
  end

  def economic_profile
    district_repo.link_economic_profiles_to_districts(name)
  end
end
