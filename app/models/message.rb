class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  validates_presence_of :context, :conversation_id, :user_id
  after_create_commit :create_notification

  def message_time
    self.created_at.strftime("%v")
  end

  private

    def create_notification
      puts "conversation_id: #{self.conversation_id}"
      if self.conversation.sender_id == self.user_id
        sender = User.find(self.conversation.sender_id)
        Notification.create!(content: "New message from #{sender.first_name} #{sender.last_name}", user_id: self.conversation.recipient_id, conversation_id: self.conversation_id, user_avatar_key: sender.avatar.key)
      else
        sender = User.find(self.conversation.recipient_id)
        Notification.create!(content: "New message from #{sender.first_name} #{sender.last_name}", user_id: self.conversation.sender_id, conversation_id: self.conversation_id, user_avatar_key: sender.avatar.key)
      end
    end
end
