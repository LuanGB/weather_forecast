require "test_helper"

class WeatherControllerTest < ActionDispatch::IntegrationTest
  setup do
    Rails.cache.clear
    geolocation_stub
    forecast_stub
  end

  test "requesting weather forecast returns empty form" do
    get root_path
    assert_response :success
    assert_matches_snapshot response.body, "weather_forecast_form"
  end

  test "requesting weather forecast with valid location returns forecast" do
    env_stub("OPEN_WEATHER_API_KEY", "OPEN_WEATHER_API_KEY") do
      get root_path, params: { line_1: "Avenida Bernardo Vieira", line_2: "", city: "Natal", state: "Rio Grande do Norte", zip: "59035-070", country: "Brazil", unit: "imperial" }
    end
    assert_response :success
    assert_matches_snapshot response.body, "weather_forecast_valid_location"
  end

  test "requesting weather forecast with valid location returns forecast with cache" do
    cache_stub("forecast/59035-070/imperial", FORECAST_BODY_DEFAULTS) do
      env_stub("OPEN_WEATHER_API_KEY", "OPEN_WEATHER_API_KEY") do
        get root_path, params: { line_1: "Avenida Bernardo Vieira", line_2: "", city: "Natal", state: "Rio Grande do Norte", zip: "59035-070", country: "Brazil", unit: "imperial" }
      end
    end
    assert_response :success
    assert_matches_snapshot response.body, "weather_forecast_valid_location_with_cache"
  end
end
