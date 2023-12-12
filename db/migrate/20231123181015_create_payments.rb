class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.string :phone_number
      t.integer :amount
      t.string :transaction_number
      t.references :user, null: false, foreign_key: true
      t.references :booking, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
