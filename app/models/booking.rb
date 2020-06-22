class Booking < ApplicationRecord
    belongs_to :user
    belongs_to :service
    has_one :provider, through: :service, source: :user
    has_one :notification
    # geocoded_by :location
    # after_validation :geocode, if: :will_save_change_to_location?
    after_create_commit :create_notification
    validates :user, :service, :date, :status, presence: true
    include PgSearch::Model
    pg_search_scope :global_search,
      against: [ :status, :date ],
      associated_against: {
        service: [ :name, :description, :location, :rate ]
      },
      using: {
        tsearch: { prefix: true }
      }


      private

      def create_notification
        puts "booking_id: #{self.id}"
        type = "New Booking Request"
        guest = User.find(self.user_id)
        Notification.create(content: "#{type} from #{guest.first_name} #{guest.last_name}", user_id: self.service.user_id, booking_id: self.id, user_avatar_key: guest.avatar.key)
      end
end
