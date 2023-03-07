class AddColumnOffDayDateInRestaurant < ActiveRecord::Migration[7.0]
  def change
    add_column :restaurants, :off_day_of_week, :integer, default: nil, array: true
  end
end
