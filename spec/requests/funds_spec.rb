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

RSpec.describe 'Funds API', type: :request do
  shared_context "prepare user and wallet" do
    before {
      @user = create(:user, name: 'rich')
      @wallet = create(:wallet, user: @user, balance: 10000)
      @amount = 100
    }

    def fund_in
      post "/api/v1/fund_in", params: {amount: @amount, user_id: @user.id}, headers: auth_header
    end
  end

  describe 'fund in' do
    include_context 'prepare user and wallet'

    it 'success' do
      fund_in
      result = JSON.parse response.body
      transaction_id = result['transaction_id']
      transact = FundTransaction.find(transaction_id)

      expect(result["code"]).to eq 0
      expect(result["balance"]).to eq (@wallet.balance + @amount).to_s
      expect(transact.amount).to eq @amount
      expect(transact.in_wallet_id).to eq @wallet.id
      expect(transact.fund_type).to eq 'fund_in'
      expect(transact.status).to eq 'success'
    end

    it 'concurrence' do
      threads = []
      counts = 30
      30.times {
        threads << Thread.new { counts.times { fund_in } }
      }
      threads.each { |thread| thread.join }
      wallet = Wallet.find(@wallet.id)
      expect(wallet.balance).to eq (@wallet.balance + @amount * threads.length * counts)
    end
  end
end
