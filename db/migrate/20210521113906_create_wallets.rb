class CreateWallets < ActiveRecord::Migration[6.0]
  def change
    create_table :wallets do |t|
      t.belongs_to :user, foreign_key: true, null: false, index: true
      t.decimal :balance, precision: 63, scale: 4, default: 0, null: false, unsigned: true
      t.timestamps
    end
  end
end
