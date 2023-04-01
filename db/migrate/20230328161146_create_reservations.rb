class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations, id: :uuid do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.integer :gender
      t.text :comment
      t.datetime :arrival_time
      t.string :state, default: 'reservated'
      t.integer :adult_quantity, default: 1
      t.integer :child_quantity, default: 0
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
