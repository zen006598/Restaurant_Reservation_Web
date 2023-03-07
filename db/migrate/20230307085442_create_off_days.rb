class CreateOffDays < ActiveRecord::Migration[7.0]
  def change
    create_table :off_days do |t|
      t.string :day, default: nil

      t.timestamps
    end
  end
end
