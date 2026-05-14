class Weather::GetForecastContract < Dry::Validation::Contract
  Dry::Validation.load_extensions(:monads)

  params do
    optional(:line_1).filled(:str?)
    optional(:line_2).filled(:str?)
    optional(:city).filled(:str?)
    optional(:state).filled(:str?)
    required(:country).filled(:str?)
    required(:unit).filled(:str?, included_in?: [ "imperial", "metric" ])
    optional(:zip).filled(:str?)
  end

  rule(:zip) do
    key.failure("must include zip unless city and state are also provided") if (values[:state].blank? && values[:city].blank?) && value.blank?
  end
end
