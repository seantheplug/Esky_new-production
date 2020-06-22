class RemovePhotoFromServices < ActiveRecord::Migration[5.2]
  def change
    remove_column :services, :photo, :string
  end
end
