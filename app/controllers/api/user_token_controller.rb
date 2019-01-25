# frozen_string_literal: true

module Api
  # ::no-doc::
  class UserTokenController < Knock::AuthTokenController
    skip_before_action :verify_authenticity_token
  end
end
