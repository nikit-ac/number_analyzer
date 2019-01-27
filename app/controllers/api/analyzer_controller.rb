# frozen_string_literal: true

# ::no-doc::
module Api
  # ::no-doc::
  class AnalyzerController < ActionController::API
    before_action :authenticate_user, except: [:create]
    include Knock::Authenticable

    def index
      render json: {}, status: :ok
    end

    def analyze
      results = numbers_params.to_h.each_with_object({}) do |(index, numbers), res|
        res[index] = NumbersAnalyzerService.new(numbers.split(',').map(&:to_f)).perform
      end

      render json: results, status: :ok
    end

    private

    def numbers_params
      params.permit(:numbers_1, :numbers_2)
    end
  end
end
