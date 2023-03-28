class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.string :serial
      t.string :name
      t.string :phone
      t.string :email
      t.integer :gender
      t.text :comment
      t.datetime :arrival_time
      t.integer :state
      t.integer :adult_quantity, default: 1
      t.integer :child_quantity, default: 0
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
