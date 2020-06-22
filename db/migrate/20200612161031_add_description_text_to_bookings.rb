class AddDescriptionTextToBookings < ActiveRecord::Migration[5.2]
  def change
    add_column :bookings, :personalize_description, :text
  end
end
