class CreateSeatModules < ActiveRecord::Migration[7.0]
  def change
    create_table :seat_modules do |t|
      t.string :title
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
