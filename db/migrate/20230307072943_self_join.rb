class SelfJoin < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :role, :integer, default: 0
    add_reference :users, :owner, foreign_key: { to_table: :users }
    add_index :user_restaurants, [:user_id, :restaurant_id], unique: true
  end
end
