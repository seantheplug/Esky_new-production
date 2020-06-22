class Notification < ApplicationRecord
  after_create_commit { NotificationJob.perform_later self }
  belongs_to :user
  belongs_to :conversation, optional: true
  belongs_to :booking, optional: true
end
