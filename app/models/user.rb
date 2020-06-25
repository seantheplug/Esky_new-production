class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :omniauthable

  has_many :bookings
  has_many :services
  has_many :reviews, through: :services
  has_many :bookings_as_providers, through: :services, source: :bookings
  has_many :notifications
  has_one :savelist
  has_one_attached :avatar
  before_save { self.email = email.downcase}
  validates :first_name, :last_name, presence: true
  validates :email, format: { with: /\A[^@]+@[^@]+\z/}, uniqueness: true

  after_create_commit :create_save_list
  
  private

  def create_save_list
    puts "create save list for user #{self.id}"
    Savelist.create!(user_id: self.id)
  end
end
