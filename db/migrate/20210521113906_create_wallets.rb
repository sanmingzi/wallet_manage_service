class CreateWallets < ActiveRecord::Migration[6.0]
  def change
    create_table :wallets do |t|
      t.decimal :balance, precision: 63, scale: 4, default: 0, null: false
      t.timestamps
    end
    add_reference :wallets, :user, index: true
  end
end
