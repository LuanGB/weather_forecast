class Weather::GetForecastContract < Dry::Validation::Contract
  Dry::Validation.load_extensions(:monads)

  params do
    optional(:line_1).filled(:str?)
    optional(:line_2).filled(:str?)
    required(:city).filled(:str?)
    required(:state).filled(:str?)
    required(:country).filled(:str?)
    required(:unit).filled(:str?, included_in?: [ "imperial", "metric" ])
    required(:zip).filled(:str?)
  end
end
