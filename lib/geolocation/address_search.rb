class Geolocation::AddressSearch
  include Dry::Monads[:result]
  def initialize; @client = Geocoder; end

  def self.get_geo_details(address)
    new.get_geo_details(address)
  end

  def get_geo_details(address)
    data = @client.search([ address.line_1, address.line_2, address.city, address.state, address.country ].join(","))

    return Failure("No results found for the provided address") if data.empty?

    data.first.tap do |location|
      return Success(lat: location.latitude, lon: location.longitude, zip: location.postal_code)
    end
  rescue StandardError => e
    Failure("Failed to fetch lat/lon: #{e.message}]")
  end
end
