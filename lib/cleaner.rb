module Cleaner
  def truncate_number(number)
    (number * 1000).floor / 1000.0
  end

  def clean_symbol(symbol)
    if symbol.to_s.downcase == 'hawaiian/pacific islander'
      symbol.to_s.downcase.split("/").last.gsub(" ", "_").gsub("`", "").to_sym
    else
      symbol.to_s.downcase.gsub(" ", "_").gsub("`", "").to_sym
    end
  end

  def create_array(string_input)
    strings = string_input.split("-")
    strings.map { |string|  string.to_i }
  end
end
