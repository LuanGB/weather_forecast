class OpenWeather::Forecast
  include Dry::Monads[:result]
  autoload :Client, "open_weather/client"

  def initialize; @client = OpenWeather::Client.new; end

  def self.get_forecast(lat:, lon:, unit:)
    new.get_forecast(lat:, lon:, unit:)
  end

  def get_forecast(lat:, lon:, unit:)
    response = @client.get("/data/2.5/weather", lat:, lon:, units: unit)

    response.bind do |res|
      data = JSON.parse(res.body)
      return Failure("Failed to fetch forecast: #{data['message']}") if data["cod"] != 200

      Success(data)
    end
  end
end
