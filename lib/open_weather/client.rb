class OpenWeather
  class Client
    include Dry::Monads[:result]
    BASE_URL = "http://api.openweathermap.org".freeze

    def get(path, params = {})
      response = Faraday.get("#{BASE_URL}#{path}", params.merge(appid: ENV.fetch("OPEN_WEATHER_API_KEY")))

      return Success(response) if response.success?

      Failure("Failed to fetch weather data: #{response.status} - #{response.body}")
    end
  end
end
