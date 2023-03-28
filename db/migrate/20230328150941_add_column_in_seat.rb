class AddColumnInSeat < ActiveRecord::Migration[7.0]
  def change
    add_column :seats, :deposit, :integer, default: 0
  end
end
