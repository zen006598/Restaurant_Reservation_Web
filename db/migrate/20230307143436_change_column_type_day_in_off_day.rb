class ChangeColumnTypeDayInOffDay < ActiveRecord::Migration[7.0]
  def change
    remove_column :off_days, :day
    add_column :off_days, :day, :date
  end
end
