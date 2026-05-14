class WeatherController < ApplicationController
  def show
    return unless weather_params.present?

    result = Weather::GetForecast.call(weather_params)

    if result.success?
      @forecast = result.value!.deep_symbolize_keys
      @unit = weather_params[:unit]
      render :show
    else
      flash.now[:error] = result.failure
      render :show, status: :unprocessable_entity
    end
  end

  private

  def weather_params
    params.permit(:line_1, :line_2, :city, :state, :country, :zip, :unit).to_h.compact_blank
  end
end
