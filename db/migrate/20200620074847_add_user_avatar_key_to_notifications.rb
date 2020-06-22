class AddUserAvatarKeyToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :user_avatar_key, :string
  end
end
