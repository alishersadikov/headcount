require 'csv'

module DataExtractor
  extend self

  def extract_data(data_hash)
    filename = extract_path(data_hash)
    filename.map do |symbol, filename|
      [symbol, (CSV.open filename, headers: true, header_converters: :symbol)]
    end
  end

  def extract_path(data_hash)
    data_hash[:enrollment]#[:kindergarten]
  end
end
