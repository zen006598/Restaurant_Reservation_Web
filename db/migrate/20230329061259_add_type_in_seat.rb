class AddTypeInSeat < ActiveRecord::Migration[7.0]
  def change
    add_column :seats, :table_type, :integer
  end
end
