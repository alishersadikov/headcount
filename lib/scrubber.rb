
module Scrubber
  def truncate_number(number)
    (number * 1000).floor / 1000.0
  end

  def clean_symbol(symbol)
    # binding.pry
    if symbol.to_s.downcase == 'hawaiian/pacific islander'
    symbol.to_s.downcase.split("/").last.gsub(" ", "_").gsub("`", "").to_sym
    # binding.pry
    else
    symbol.to_s.downcase.gsub(" ", "_").gsub("`", "").to_sym
    # if symbol.to_s.include?(" ")
    #   symbol.to_s.downcase.gsub(" ", "_").gsub(/\s+/, "").gsub("`", "").to_sym
    # else
    #   symbol.to_s.downcase.gsub(/\s+/, "").gsub("`", "").to_sym
    end
  end
end
