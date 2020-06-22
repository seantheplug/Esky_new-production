class AddCoordinatesToTable < ActiveRecord::Migration[5.2]
  def change
    add_column :services, :latitude, :float
    add_column :services, :longitude, :float
  end
end
