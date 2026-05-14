require "test_helper"

class Weather::GetForecastTest < ActiveSupport::TestCase
  REQUIRED_FIELDS = %i[city state country unit zip].freeze

  setup do
    Rails.cache.clear
    @valid_input = { line_1: "Avenida Bernardo Vieira", city: "Natal", state: "Rio Grande do Norte", zip: "59035-070", country: "Brazil", unit: "imperial" }
  end

  REQUIRED_FIELDS.each do |field|
    test "with missing #{field}" do
      response = Weather::GetForecast.call(@valid_input.except(field))
      assert response.failure?
      assert_equal [ "is missing" ], response.failure.errors.to_h[field]
    end
  end

  test "with valid input" do
    geolocation_stub
    forecast_stub
    response = env_stub("OPEN_WEATHER_API_KEY", "OPEN_WEATHER_API_KEY") do
      Weather::GetForecast.call(@valid_input)
    end
    assert response.success?
  end

  test "twice with same input with cache" do
    geolocation_stub
    forecast_stub
    response = env_stub("OPEN_WEATHER_API_KEY", "OPEN_WEATHER_API_KEY") do
      Weather::GetForecast.call(@valid_input)
      Weather::GetForecast.call(@valid_input)
    end
    assert response.success?
    assert_equal true, response.value![:cached]
  end

  test "with invalid location" do
    geolocation_stub_failure
    forecast_stub
    response = env_stub("OPEN_WEATHER_API_KEY", "OPEN_WEATHER_API_KEY") do
      Weather::GetForecast.call(@valid_input.merge(city: "Invalid City", state: "Invalid State", country: "Invalid Country", zip: "00000").except(:line_1))
    end
    assert response.failure?
    assert_equal "No results found for the provided address", response.failure
  end

  test "with forecast api failure" do
    geolocation_stub
    forecast_stub_failure
    response = env_stub("OPEN_WEATHER_API_KEY", "OPEN_WEATHER_API_KEY") do
      Weather::GetForecast.call(@valid_input)
    end
    assert response.failure?
    assert_equal "Failed to fetch forecast", response.failure
  end
end
