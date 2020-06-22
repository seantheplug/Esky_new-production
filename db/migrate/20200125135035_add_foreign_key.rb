class AddForeignKey < ActiveRecord::Migration[5.2]
  def change
    add_reference :bookings, :service, foreign_key: true
    add_reference :bookings, :user, foreign_key: true
    add_reference :services, :user, foreign_key: true
    add_reference :reviews, :service, foreign_key: true
    add_reference :reviews, :user, foreign_key: true
  end
end
