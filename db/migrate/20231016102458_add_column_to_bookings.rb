class AddColumnToBookings < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :user_id, :integer
    add_column :bookings, :room_id, :integer

    add_foreign_key :bookings, :users, column: :user_id
    add_foreign_key :bookings, :rooms, column: :room_id

  
  end
end
