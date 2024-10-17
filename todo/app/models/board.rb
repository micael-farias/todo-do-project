class Board < ApplicationRecord
    belongs_to :user
    has_many :board_items, dependent: :destroy
  
    accepts_nested_attributes_for :board_items, allow_destroy: true
  
    validates :title, presence: true
end
  