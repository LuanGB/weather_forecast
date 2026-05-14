require Rails.root.join("lib/open_weather")

module Weather
  class GetForecast < Dry::Operation
    def self.call(input)
      new.call(input)
    end

    def call(input)
      attrs = (step validate_input(input)).to_h

      geo_details = step fetch_geo_details(attrs)

      step fetch_forecast(geo_details[:lat], geo_details[:lon], attrs[:zip] || geo_details[:zip], attrs[:unit])
    end

    private

    def validate_input(input)
      GetForecastContract.new.call(input).to_monad
    end

    def fetch_geo_details(attrs)
      Geocoder::AddressSearch.get_geo_details(**attrs.slice(:line_1, :line_2, :city, :state, :country))
    end

    def fetch_forecast(lat, lon, zip, unit)
      cached_forecast = Rails.cache.fetch("forecast/#{zip}/#{unit}")
      return Success(cached_forecast.merge(cached: true)) if cached_forecast

      response = OpenWeather::Forecast.get_forecast(lat:, lon:, unit:)

      return Failure("Failed to fetch forecast") if response.failure?

      Rails.cache.write(
        "forecast/#{zip}/#{unit}",
        response.value!,
        expires_in: 30.minutes
      )
      Success(response.value!.merge(cached: false))
    end
  end
end
