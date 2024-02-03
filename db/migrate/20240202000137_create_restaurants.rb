class CreateRestaurants < ActiveRecord::Migration[7.0]
  def change
    create_table :restaurants do |t|
      t.string :menu
      t.string :image
      t.timestamps
    end
  end
end
