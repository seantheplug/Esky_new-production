class ChangeDateToBeDateInBookings < ActiveRecord::Migration[5.2]
  def change
    change_column :bookings, :date, :date
  end
end
