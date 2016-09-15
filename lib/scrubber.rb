
module Scrubber
  def truncate_number(number)
    (number * 1000).floor / 1000.0
  end
end
