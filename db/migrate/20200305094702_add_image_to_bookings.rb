class AddImageToBookings < ActiveRecord::Migration[5.2]
  def change
    add_column :bookings, :image, :string
  end
end
