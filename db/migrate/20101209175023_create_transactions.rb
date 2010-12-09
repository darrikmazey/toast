class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.datetime :transaction_date
      t.string :description
      t.float :amount
      t.references :account

      t.timestamps
    end
  end

  def self.down
    drop_table :transactions
  end
end
