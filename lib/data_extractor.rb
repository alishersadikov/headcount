require 'csv'

module DataExtractor
  extend self

  def extract_data(data_hash)
    filename = extract_path(data_hash)
    contents = filename.map do |district_criteria, file|
      [district_criteria, (CSV.open file, headers: true, header_converters: :symbol)]
    end
  end

  def extract_path(data_hash)
    return data_hash[:statewide_testing] if data_hash[:statewide_testing]
    return data_hash[:enrollment] if data_hash[:enrollment]
  end
end
