require 'rails_helper'

Apis = [
  ['get', '/api/v1/balance/1'],
  ['post', '/api/v1/fund_in'],
  ['post', '/api/v1/fund_out'],
  ['post', '/api/v1/transfer']
]

RSpec.describe 'Authenticate fail', type: :request do
  before {
    create(:user, name: 'rich')
  }

  describe 'no token' do
    Apis.each do |method, api|
      it api do
        eval("#{method} '#{api}'")
        result = JSON.parse response.body
        expect(response).to have_http_status(:unauthorized)
        expect(result["code"]).to eq 401
      end
    end
  end

  describe 'invalid token' do
    Apis.each do |method, api|
      it api do
        eval("#{method} '#{api}', headers: {'Authorization': 'invalid token'}")
        result = JSON.parse response.body
        expect(response).to have_http_status(:unauthorized)
        expect(result["code"]).to eq 401
      end
    end
  end

  describe 'token is expired' do
    Apis.each do |method, api|
      it api do
        eval("#{method} '#{api}', headers: #{expired_auth_header.to_s}")
        result = JSON.parse response.body
        expect(response).to have_http_status(:unauthorized)
        expect(result["code"]).to eq 401
      end
    end
  end
end
