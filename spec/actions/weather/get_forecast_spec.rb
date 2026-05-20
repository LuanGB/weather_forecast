require "rails_helper"

RSpec.describe Weather::GetForecast do
  let(:valid_input) do
    { line_1: "Avenida Bernardo Vieira", city: "Natal", state: "Rio Grande do Norte", zip: "59035-070", country: "Brazil", unit: "imperial" }
  end

  %i[city state country unit zip].each do |field|
    context "with missing #{field}" do
      it "returns a failure" do
        response = described_class.call(valid_input.except(field))
        expect(response).to be_failure
        expect(response.failure.errors.to_h[field]).to eq([ "is missing" ])
      end
    end
  end

  context "with valid input" do
    it "returns success" do
      geolocation_stub
      forecast_stub
      response = env_stub("OPEN_WEATHER_API_KEY", "OPEN_WEATHER_API_KEY") do
        described_class.call(valid_input)
      end
      expect(response).to be_success
    end
  end

  context "called twice with same input" do
    it "uses cache on second call" do
      geolocation_stub
      forecast_stub
      response = env_stub("OPEN_WEATHER_API_KEY", "OPEN_WEATHER_API_KEY") do
        described_class.call(valid_input)
        described_class.call(valid_input)
      end
      expect(response).to be_success
      expect(response.value![:cached]).to be true
    end
  end

  context "with invalid location" do
    it "returns a failure with location error message" do
      geolocation_stub_failure
      forecast_stub
      response = env_stub("OPEN_WEATHER_API_KEY", "OPEN_WEATHER_API_KEY") do
        described_class.call(valid_input.merge(city: "Invalid City", state: "Invalid State", country: "Invalid Country", zip: "00000").except(:line_1))
      end
      expect(response).to be_failure
      expect(response.failure).to eq("No results found for the provided address")
    end
  end

  context "with forecast api failure" do
    it "returns a failure with api error message" do
      geolocation_stub
      forecast_stub_failure
      response = env_stub("OPEN_WEATHER_API_KEY", "OPEN_WEATHER_API_KEY") do
        described_class.call(valid_input)
      end
      expect(response).to be_failure
      expect(response.failure).to eq("Failed to fetch forecast")
    end
  end
end
