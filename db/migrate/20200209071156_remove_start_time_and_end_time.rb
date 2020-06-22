class RemoveStartTimeAndEndTime < ActiveRecord::Migration[5.2]
  def change
    remove_column :bookings, :start_time
    remove_column :bookings, :end_time
    add_column :bookings, :date, :datetime
  end
end
