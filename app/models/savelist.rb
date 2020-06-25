class Savelist < ApplicationRecord
    belongs_to :user
    has_many :savelistspointers, dependent: :destroy
    has_many :services, through: :savelistspointers
  end