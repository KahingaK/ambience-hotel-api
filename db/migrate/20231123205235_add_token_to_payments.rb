class AddTokenToPayments < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :checkout, :string
  end
end
