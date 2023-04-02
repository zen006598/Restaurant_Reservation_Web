class AddColumnDepositInRestaurant < ActiveRecord::Migration[7.0]
  def change
    add_column :restaurants, :deposit, :integer, default: 0
    add_column :restaurants, :headcount_requirement, :integer, default: 99
  end
end
