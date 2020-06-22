class AddUserBookingToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_reference :notifications, :booking, foreign_key: true
  end
end
