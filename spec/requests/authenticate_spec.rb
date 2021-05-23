require 'rails_helper'


RSpec.describe 'Authenticate fail', type: :request do
  [
    ['get', '/api/v1/balance/1'],
    ['post', '/api/v1/fund_in'],
    ['post', '/api/v1/fund_out'],
    ['post', '/api/v1/transfer']
  ].each do |method, api|
    it api do
      eval("#{method} '#{api}'")
      result = JSON.parse response.body
      expect(response).to have_http_status(:unauthorized)
      expect(result["code"]).to eq 401
    end
  end
end
