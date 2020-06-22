class AddConversationReferenceToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_reference :notifications, :conversation, foreign_key: true
  end
end
