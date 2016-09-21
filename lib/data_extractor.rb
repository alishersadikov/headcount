require 'csv'

module DataExtractor

  def self.extract_data(filename)
    filename.map do |district_criteria, file|
      [district_criteria,
        (CSV.open file, headers: true, header_converters: :symbol)]
    end
  end
end
