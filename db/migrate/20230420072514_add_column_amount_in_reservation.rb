class AddColumnAmountInReservation < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :capitation, :integer, default: 0
  end
end
