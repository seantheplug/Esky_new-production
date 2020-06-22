class FixedStarTypo < ActiveRecord::Migration[5.2]
  def change
    remove_column :reviews, :star
    add_column :reviews, :stars, :integer
  end
end
