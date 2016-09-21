class UnknownDataError < StandardError
  def message(grade)
    "#{grade} is not a known grade"
  end
end

class UnknownRaceError < StandardError

end

class InsufficientInformationError < StandardError
  def message
    "A grade must be provided to answer this question"
  end
end
