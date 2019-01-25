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
  end
end
