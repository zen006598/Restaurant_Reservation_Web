class RemoveColumnOffDayOfWeekFromRestaurant < ActiveRecord::Migration[7.0]
  def change
    remove_column :restaurants ,:off_day_of_week
  end
end
