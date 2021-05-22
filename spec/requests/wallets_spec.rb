require 'rails_helper'

def auth_header
  {'Authorization' => auth_token}
end

def auth_token(user = User.first)
  payload = {
    user_id: user.id
  }
  token = JsonWebToken.encode(payload)
  "Bearer #{token}"
end

RSpec.describe 'Wallets API', type: :request do
  # it 'authenticate failed' do
  #   get '/api/v1/balance/1'
  #   result = JSON.parse response.body
  #   expect(response).to have_http_status(:success)
  #   expect(result["code"]).to eq 401
  # end

  it 'get balance success' do
    user = create(:user, name: 'rich')
    wallet = create(:wallet, user: user, balance: 10000)

    get "/api/v1/balance/#{user.id}", headers: auth_header
    result = JSON.parse response.body
    expect(result["code"]).to eq 0
    expect(result["balance"]).to eq wallet.balance.to_s
  end
end
