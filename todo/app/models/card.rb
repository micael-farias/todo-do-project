# app/models/card.rb
class Card < ApplicationRecord
  belongs_to :board_item
  acts_as_list scope: :board_item

  validates :title, presence: true
  scope :incomplete, -> { where(completed: [false, nil]) }
end
