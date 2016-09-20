require_relative '../lib/scrubber'

class EconomicProfile
  include Scrubber
  attr_reader :name,
              :median_household_income,
              :children_in_poverty,
              :free_or_reduced_price_lunch,
              :title_i

  def initialize(economic_profile_data)
    @name = economic_profile_data || ""
    @median_household_income     = economic_profile_data[
                                    :median_household_income] || {}
    @children_in_poverty         = economic_profile_data[
                                    :children_in_poverty] || {}
    @free_or_reduced_price_lunch = economic_profile_data[
                                    :free_or_reduced_price_lunch] || {}
    @title_i                     = economic_profile_data[:title_i] || {}
  end

  def median_household_income_in_year(year)
    incomes = []
    median_household_income.each do |key, value|
      incomes << value if year.between?(key[0], key[1])
    end
    calculate_average(incomes)
  end

  def median_household_income_average
    calculate_average(median_household_income.values)
  end

  def children_in_poverty_in_year(year)
    truncate_number(children_in_poverty[year])
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    free_or_reduced_price_lunch[year][:percentage]
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    free_or_reduced_price_lunch[year][:total]
  end

  def title_i_in_year(year)
    title_i[year]
  end

  private

  def calculate_average(collection)
    collection.reduce { |sum, element|  sum + element } / collection.size
  end
end
