class ChangeDefaultStateInReservation < ActiveRecord::Migration[7.0]
  def change
    change_column_default :reservations, :state, 'pending'
  end
end
