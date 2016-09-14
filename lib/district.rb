class District
  attr_reader :name
  
  def initialize(district_data)
    @name = district_data[:name].upcase
  end
end
