class WeatherController < ApplicationController
  def show
    return unless weather_params.present?

    result = Weather::GetForecast.call(weather_params)

    if result.success?
      @forecast = result.value!.deep_symbolize_keys
      @unit = weather_params[:unit]
      render :show
    else
      error_message = if result.failure.respond_to?(:errors)
        result.failure.errors.to_h.map { |k, v| "#{k} #{v.join(", ")}" }.join(", ")
      else
          result.failure
      end
      flash.now[:error] = error_message
      render :show, status: :unprocessable_entity
    end
  end

  private

  def weather_params
    params.permit(:line_1, :line_2, :city, :state, :country, :zip, :unit).to_h.compact_blank
  end
end
