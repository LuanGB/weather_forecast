FORECAST_URL_DEFAULTS = { appid: "OPEN_WEATHER_API_KEY", lat: "-5.8015083", lon: "-35.2363778", units: "imperial" }.freeze

FORECAST_BODY_DEFAULTS = {
  "coord": { "lon": -35.2364, "lat": -5.8015 },
  "weather": [ { "id": 500, "main": "Rain", "description": "light rain", "icon": "10d" } ], "wind": { "speed": 9.22, "deg": 180 },
  "base": "stations", "visibility": 10000, "dt": 1778765441, "timezone": -10800, "id": 3394023, "name": "Natal", "cod": 200,
  "main": { "temp": 75.4, "feels_like": 77.05, "temp_min": 75.4, "temp_max": 75.85, "pressure": 1014, "humidity": 94, "sea_level": 1014, "grnd_level": 1010 },
  "rain": { "1h": 0.39 }, "clouds": { "all": 75 }, "sys": { "type": 1, "id": 8417, "country": "BR", "sunrise": 1778746902, "sunset": 1778789582 }
}.freeze

FORECAST_BODY_FAILURE_DEFAULTS = { "cod": 401, "message": "Invalid API key. Please see https://openweathermap.org/faq#error401 for more info." }

def forecast_stub(url_options: {}, override_body: {})
  url = URI::HTTP.build(host: "api.openweathermap.org", path: "/data/2.5/weather", query: FORECAST_URL_DEFAULTS.merge(url_options).to_query).to_s
  body = FORECAST_BODY_DEFAULTS.merge(override_body)
  stub_request(:get, url).
    with(
      headers: { "Accept"=>"*/*", "Accept-Encoding"=>"gzip;q=1.0,deflate;q=0.6,identity;q=0.3", "User-Agent"=>"Faraday v2.14.1" }).
    to_return(status: 200, body: body.to_json, headers: {})
end

def forecast_stub_failure(url_options: {}, override_body: {})
  url = URI::HTTP.build(host: "api.openweathermap.org", path: "/data/2.5/weather", query: FORECAST_URL_DEFAULTS.merge(url_options).to_query).to_s
  body = FORECAST_BODY_FAILURE_DEFAULTS.merge(override_body)
  stub_request(:get, url).
    with(
      headers: { "Accept"=>"*/*", "Accept-Encoding"=>"gzip;q=1.0,deflate;q=0.6,identity;q=0.3", "User-Agent"=>"Faraday v2.14.1" }).
    to_return(status: 401, body: body.to_json, headers: {})
end
