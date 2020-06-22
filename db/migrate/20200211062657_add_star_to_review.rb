class AddStarToReview < ActiveRecord::Migration[5.2]
  def change
    remove_column :reviews, :rating
    add_column :reviews, :star, :integer
  end
end
