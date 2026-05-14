class Geocoder::AddressSearch
  include Dry::Monads[:result]
  def initialize; @client = Geocoder; end

  def self.get_geo_details(line_1: nil, line_2: nil, city: nil, state: nil, country: nil)
    new.get_geo_details(line_1:, line_2:, city:, state:, country:)
  end

  def get_geo_details(line_1:, line_2:, city:, state:, country:)
    data = @client.search([ line_1, line_2, city, state, country ].join(","))

    return Failure("No results found for the provided address") if data.empty?

    data.first.tap do |location|
      return Success(lat: location.latitude, lon: location.longitude, zip: location.postal_code)
    end
  rescue StandardError => e
    Failure("Failed to fetch lat/lon: #{e.message}]")
  end
end
