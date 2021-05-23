class Wallet < ApplicationRecord
  belongs_to :user

  validates :balance, numericality: {greater_than_or_equal_to: 0}

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

  def fund_out(amount)
    Rails.logger.info "amount: #{amount}, balance: #{self.balance}"
    transact = nil
    transaction do
      self.decrement!(:balance, amount)
      transact = FundTransaction.create!(
        amount: amount,
        fund_type: 'fund_out',
        out_wallet_id: self.id,
        status: 'success'
      )
    end
    transact
  rescue ActiveRecord::RangeError => e
    self.reload
    Rails.logger.info "error_message: #{e.message}"
    Rails.logger.info "message: not sufficient funds, balance: #{self.balance}, amount: #{amount}"
    nil
  end
end
