class CreateServices < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
      t.integer :rate
      t.string :location
      t.float :rating
      t.string :description

      t.timestamps
    end
  end
end
