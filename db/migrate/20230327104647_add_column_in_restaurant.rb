class AddColumnInRestaurant < ActiveRecord::Migration[7.0]
  def change
    add_column :restaurants, :dining_time, :integer, default: 0
    add_column :restaurants, :interval_time, :integer, default: 0        
    add_column :restaurants, :period_of_reservation, :integer, default: 0        
  end
end
