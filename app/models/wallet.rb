class Wallet < ApplicationRecord
  belongs_to :user

  def fund_in(amount)
    transact = nil
    transaction do
      self.increment!(:balance, amount)
      transact = FundTransaction.create!(
        amount: amount,
        fund_type: 'fund_in',
        in_wallet_id: self.id,
        status: 'success'
      )
    end
    transact
  end
end
