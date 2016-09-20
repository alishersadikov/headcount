class EconomicProfile
  attr_reader :name,
              :median_household_income,
              :children_in_poverty,
              :free_or_reduced_price_lunch,
              :title_i

  def initialize(economic_profile_data)
    @name = economic_profile_data[:name].upcase
    @median_household_income     = economic_profile_data[:median_household_income] || {}
    @children_in_poverty         = economic_profile_data[:children_in_poverty] || {}
    @free_or_reduced_price_lunch = economic_profile_data[:free_or_reduced_price_lunch] || {}
    @title_i                     = economic_profile_data[:title_i] || {}
  end


end
