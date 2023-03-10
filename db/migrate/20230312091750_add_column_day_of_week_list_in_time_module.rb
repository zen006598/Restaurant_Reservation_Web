class AddColumnDayOfWeekListInTimeModule < ActiveRecord::Migration[7.0]
  def change
    add_column :time_modules, :day_of_week_list, :integer, array: true
  end
end
