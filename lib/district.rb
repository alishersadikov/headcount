class District
  attr_reader   :name
  attr_accessor :enrollment

  def initialize(district_data)
    @name = district_data[:name].upcase
  end

end
