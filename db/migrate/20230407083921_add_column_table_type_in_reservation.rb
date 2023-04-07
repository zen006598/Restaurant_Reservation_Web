class AddColumnTableTypeInReservation < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :table_type, :integer
  end
end
