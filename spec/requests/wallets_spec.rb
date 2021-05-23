require 'rails_helper'

RSpec.describe 'Wallets API', type: :request do
  it 'get balance success' do
    user = create(:user, name: 'rich')
    wallet = create(:wallet, user: user, balance: 10000)

    get "/api/v1/balance/#{user.id}", headers: auth_header
    result = JSON.parse response.body
    expect(result["code"]).to eq 0
    expect(result["balance"]).to eq wallet.balance.to_s
  end
end
