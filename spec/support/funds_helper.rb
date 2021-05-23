module FundsHelper
  def fund_in
    post "/api/v1/fund_in", params: { amount: @amount, user_id: @user.id }, headers: auth_header(@user)
  end

  def fund_out
    post "/api/v1/fund_out", params: {amount: @amount, user_id: @user.id}, headers: auth_header(@user)
  end

  def transfer
    post "/api/v1/transfer", params: {amount: @amount, out_user_id: @user.id, in_user_id: @in_user.id}, headers: auth_header(@user)
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
end
