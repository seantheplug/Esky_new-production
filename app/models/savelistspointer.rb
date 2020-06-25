class Savelistspointer < ApplicationRecord
    belongs_to :savelist
    belongs_to :service
    validates :savelist, uniqueness: { scope: :service }
  end