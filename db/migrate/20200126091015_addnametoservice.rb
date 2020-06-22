class Addnametoservice < ActiveRecord::Migration[5.2]
  def change
    add_column :services, :name, :string
  end
end
