class CreateFundTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :fund_transactions do |t|
      t.decimal :amount, precision: 63, scale: 4, null: false
      t.string :fund_type, null: false #fund_in fund_out transfer
      t.bigint :in_wallet_id, index: true
      t.bigint :out_wallet_id, index: true
      t.string :status
      t.string :description
    end
  end
end
