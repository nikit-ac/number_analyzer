# frozen_string_literal: true

module Api
  # ::no-doc::
  class UsersController < AnalyzerController
    include ActionController::RequestForgeryProtection
    protect_from_forgery

    # POST /signup
    def create
      @user = User.new(user_params)
      if @user.save
        render json: {}, status: :created
      else
        render json: @user.errors, status: :bad_request
      end
    end

    def show
      render json: { login: current_user.login }, status: :ok
    end

    private

    def user_params
      params.permit(
        :login,
        :password,
        :password_confirmation
      )
    end
  end
end
