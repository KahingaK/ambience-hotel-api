class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.string :room_number
      t.string :room_type
      t.text :description
      t.integer :price
      t.integer :capacity
      t.boolean :available, default: true

      t.timestamps
    end
  end
end
