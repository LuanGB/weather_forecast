require "rails_helper"

RSpec.describe "Weather", type: :request do
  before do
    geolocation_stub
    forecast_stub
  end

  describe "GET /" do
    it "returns empty form" do
      get root_path
      expect(response).to have_http_status(:success)
      expect(response.body).to match_snapshot("weather_forecast_form")
    end

    it "with valid location returns forecast" do
      env_stub("OPEN_WEATHER_API_KEY", "OPEN_WEATHER_API_KEY") do
        get root_path, params: { line_1: "Avenida Bernardo Vieira", line_2: "", city: "Natal", state: "Rio Grande do Norte", zip: "59035-070", country: "Brazil", unit: "imperial" }
      end
      expect(response).to have_http_status(:success)
      expect(response.body).to match_snapshot("weather_forecast_valid_location")
    end

    it "with valid location and cache returns forecast" do
      cache_stub("forecast/59035-070/imperial", FORECAST_BODY_DEFAULTS) do
        env_stub("OPEN_WEATHER_API_KEY", "OPEN_WEATHER_API_KEY") do
          get root_path, params: { line_1: "Avenida Bernardo Vieira", line_2: "", city: "Natal", state: "Rio Grande do Norte", zip: "59035-070", country: "Brazil", unit: "imperial" }
        end
      end
      expect(response).to have_http_status(:success)
      expect(response.body).to match_snapshot("weather_forecast_valid_location_with_cache")
    end
  end
end
