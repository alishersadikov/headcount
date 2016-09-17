
module Scrubber
  def truncate_number(number)
    (number * 1000).floor / 1000.0
  end

  def clean_symbol(symbol)
    if symbol.to_s.include?(" ")
      symbol.to_s.downcase.gsub!(" ", "_").gsub!(/\W+/, '').to_sym
    else
      symbol.to_s.downcase.gsub!(/\W+/, '').to_sym
  end
end
