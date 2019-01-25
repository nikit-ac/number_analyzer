# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::AnalyzerController, type: :controller do
  def authenticated_header(user)
    token = Knock::AuthToken.new(payload: { sub: user.id }).token
    { 'Authorization': "Bearer #{token}" }
  end

  describe 'Authorization' do
    URL = 'index'
    AUTH_URL = 'api/user_token'

    context 'when the request with NO authentication header' do
      it 'should return unauth for retrieve current user info before login' do
        get URL
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the request contains an authentication header' do
      it 'should return the user info' do
        user = User.create("login": 'test_login', "password": 'test_password')
        request.headers.merge!(authenticated_header(user))
        get URL, params: {}
      end
    end
  end
end
