require 'rails_helper'

def concurrence(thread_number, counts, &block)
  threads = []
  thread_number.times {
    threads << Thread.new { counts.times(&block) }
  }
  threads.each { |thread| thread.join }
end

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
      @wallet = create(:wallet, user: @user, balance: 1000000)
      @amount = 100
    }
  end

  def get_response
    result = JSON.parse response.body
    transaction_id = result['transaction_id']
    transact = FundTransaction.find(transaction_id)
    [result, transact]
  end

  def check_balance(wallet, balance)
    wallet.reload
    expect(wallet.balance).to eq balance
  end

  describe 'fund in' do
    include_context 'prepare user and wallet'

    def fund_in
      post "/api/v1/fund_in", params: {amount: @amount, user_id: @user.id}, headers: auth_header
    end

    it 'success' do
      fund_in
      result, transact = get_response

      expect(result["code"]).to eq 0
      expect(result["balance"]).to eq (@wallet.balance + @amount).to_s
      expect(transact.amount).to eq @amount
      expect(transact.in_wallet_id).to eq @wallet.id
      expect(transact.fund_type).to eq 'fund_in'
      expect(transact.status).to eq 'success'
    end

    it 'concurrence' do
      thread_number, counts = 30, 10
      total_counts = thread_number * counts
      concurrence(thread_number, counts) { fund_in }
      origin_balance = @wallet.balance
      @wallet.reload
      expect(@wallet.balance).to eq origin_balance + @amount * total_counts
      expect(FundTransaction.all.length).to eq total_counts
    end
  end

  describe 'fund out' do
    include_context 'prepare user and wallet'

    def fund_out
      post "/api/v1/fund_out", params: {amount: @amount, user_id: @user.id}, headers: auth_header
    end

    it 'success' do
      fund_out
      result, transact = get_response
      expect(result["code"]).to eq 0
      expect(result["balance"]).to eq (@wallet.balance - @amount).to_s
      expect(transact.amount).to eq @amount
      expect(transact.out_wallet_id).to eq @wallet.id
      expect(transact.fund_type).to eq 'fund_out'
      expect(transact.status).to eq 'success'
    end

    it 'not sufficient funds' do
      @amount = @wallet.balance + 100
      fund_out
      result = JSON.parse response.body
      expect(result["code"]).to eq 1
      expect(result["balance"]).to eq @wallet.balance.to_s
      @wallet.reload
      expect(result["balance"]).to eq @wallet.balance.to_s
      expect(FundTransaction.all.empty?).to eq true
    end

    it 'concurrence' do
      # TODO
      thread_number, counts = 1, 10
      total_counts = thread_number * counts
      concurrence(thread_number, counts) { fund_out }
      origin_balance = @wallet.balance
      @wallet.reload
      expect(@wallet.balance).to eq origin_balance - @amount * total_counts
      expect(FundTransaction.all.length).to eq total_counts
    end
  end

  describe 'transfer' do
    include_context 'prepare user and wallet'

    before {
      @in_user = create(:user, name: 'transfer_in')
      @in_wallet = create(:wallet, user: @in_user, balance: 1000000)
    }

    def transfer
      post "/api/v1/transfer", params: {amount: @amount, out_user_id: @user.id, in_user_id: @in_user.id}, headers: auth_header
    end

    it 'success' do
      transfer
      result, transact = get_response
      expect(result["code"]).to eq 0
      expect(result["balance"]).to eq (@wallet.balance - @amount).to_s
      expect(transact.amount).to eq @amount
      expect(transact.out_wallet_id).to eq @wallet.id
      expect(transact.in_wallet_id).to eq @in_wallet.id
      expect(transact.fund_type).to eq 'transfer'
      expect(transact.status).to eq 'success'
      check_balance(@wallet, @wallet.balance - @amount)
      check_balance(@in_wallet, @in_wallet.balance + @amount)
    end

    it 'not sufficient funds' do
      @amount = @wallet.balance + 100
      transfer
      result = JSON.parse response.body
      expect(result["code"]).to eq 1
      check_balance(@wallet, @wallet.balance)
      expect(result["balance"]).to eq @wallet.balance.to_s
      expect(FundTransaction.all.empty?).to eq true
    end

    it 'concurrence' do
      # TODO
      thread_number, counts = 1, 10
      total_counts = thread_number * counts
      concurrence(thread_number, counts) { transfer }
      check_balance(@wallet, @wallet.balance - @amount * total_counts)
      check_balance(@in_wallet, @in_wallet.balance + @amount * total_counts)
      expect(FundTransaction.all.length).to eq total_counts
    end
  end
end
