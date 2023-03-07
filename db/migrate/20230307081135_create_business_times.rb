class CreateBusinessTimes < ActiveRecord::Migration[7.0]
  def change
    create_table :business_times do |t|
      t.time :start
      t.time :_end
      t.references :time_module, null: false, foreign_key: true

      t.timestamps
    end
  end
end
