# Weather Forecast

A Ruby on Rails application that fetches current weather data for a given address. It resolves coordinates via [Nominatim](https://operations.osmfoundation.org/policies/nominatim/) using the [Geocoder gem](https://github.com/alexreisner/geocoder) and retrieves weather data from [OpenWeatherMap](https://openweathermap.org/). Results are cached for 30 minutes to avoid redundant API calls.

## Features

- Address-based weather lookup (address lines, city, state, zip code, country)
- Temperature display in Fahrenheit or Celsius
- Shows temperature, feels like, min/max, humidity, wind speed and direction
- 30-minute response caching per zip code + unit combination
- Indicates whether the result was served from cache

## Tech Stack

- **Ruby** 3.4.5 / **Rails** 8.0
- **SQLite3** — database (Solid Cache, Solid Queue, Solid Cable)
- **Nominatim** — address to coordinates resolution
- **OpenWeatherMap API** — weather data
- **dry-operation / dry-validation / dry-monads** — input validation and service layer
- **Faraday** — HTTP client

## Requirements

- Ruby 3.4.5
- Bundler
- An [OpenWeatherMap API key](https://openweathermap.org/api)

## Setup

```bash
bundle install
cp .env.example .env
```

Edit `.env` and add your API key:

```
OPEN_WEATHER_API_KEY=your_key_here
```

This value can be fetched by subscribing to Open Weather and accessing this link: https://home.openweathermap.org/api_keys

Initialize the database:

```bash
bin/rails db:prepare
```

## Running

```bash
bin/dev
```
or

```bash
rails s
```

The app will be available at `http://localhost:3000`.

## Running Tests

```bash
bin/rails test
```

## Architecture

Requests flow through a service object (`Weather::GetForecast`) that:

1. Validates the input via `Weather::GetForecastContract` (dry-validation)
2. Resolves the address to coordinates via the Nominatim API
3. Checks `Rails.cache` for a cached forecast (keyed by zip + unit)
4. If not cached, fetches from OpenWeatherMap and writes to cache with a 30-minute TTL
