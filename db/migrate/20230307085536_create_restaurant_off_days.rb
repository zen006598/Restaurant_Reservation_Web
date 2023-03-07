class CreateRestaurantOffDays < ActiveRecord::Migration[7.0]
  def change
    create_table :restaurant_off_days do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.references :off_day, null: false, foreign_key: true

      t.timestamps
    end
  end
end
