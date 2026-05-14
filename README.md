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
- **SQLite3** - database (Solid Cache, Solid Queue, Solid Cable)
- **Nominatim / Geocoder gem** - address to coordinates resolution
- **OpenWeatherMap API** - weather data
- **dry-operation / dry-validation / dry-monads** - input validation and service layer
- **Faraday** - HTTP client

## Requirements

- Ruby 3.4.5
- Bundler
- An OpenWeatherMap API key (More info below)

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

---

## Approach

The core problem breaks down into three steps: validate user input, resolve an address to geographic coordinates, and fetch weather data - caching the result to avoid hitting the API on repeated requests for the same location.

Each step is modeled as an explicit, sequential operation inside `Weather::GetForecast`, which inherits from `Dry::Operation`. This makes the happy path readable top-to-bottom and short-circuits automatically on any failure, without nested conditionals or exceptions for control flow.

The cache key is `forecast/<zip>/<unit>`, set with a 30-minute TTL using Rails' built-in caching layer (backed by Solid Cache). This means repeated lookups for the same zip code and unit return immediately from the database without an external HTTP call.

## Rationale

**dry-operation / dry-validation / dry-monads** - These gems enforce an explicit pipeline where each step returns either a `Success` or `Failure`. This eliminates `nil` checks and exception-driven control flow, and makes error propagation predictable. The contract (`GetForecastContract`) also centralizes all input validation in one place, keeping the controller thin.

**Geocoder gem** - Provides a clean abstraction over geocoding backends. Using Nominatim as the backend avoids paid API keys for address resolution, which is a reasonable default for a demo application.

**Faraday** - A straightforward HTTP client with middleware support. Used here to keep external API calls isolated behind dedicated wrapper classes (`OpenWeather::Forecast`), which makes them easy to stub in tests.

**Minitest with snapshot testing** - Snapshot tests on controller responses catch unexpected changes to the rendered HTML without having to enumerate every field manually. `webmock` stubs all external HTTP calls so tests are fast and deterministic.

## What I Would Do Next

- **UI polish** - The current view is functional but unstyled. Adding Tailwind CSS or even basic scoped CSS would significantly improve the user experience.
- **Error UX** - Field-level error messages inline with the form instead of a single flash message at the bottom.
- **Multi-day forecast** - OpenWeatherMap's free tier exposes other endpoints for multi-day forecasts. Displaying this as a daily summary would make the app more useful.
- **Auto-detect location** - Use the browser Geolocation API to pre-fill the form based on the user's current position.
- **Rate limiting** - Add request throttling (e.g. via Rack::Attack) to prevent abuse of the upstream APIs.
- **Observability** - Instrument cache hit/miss rates and external API latency with Rails instrumentation hooks so it's possible to monitor performance in production.
