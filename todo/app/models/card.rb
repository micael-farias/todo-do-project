# app/models/card.rb
class Card < ApplicationRecord
  belongs_to :board_item
  acts_as_list scope: :board_item
  belongs_to :mood, optional: true # Torna o humor opcional, se necessário
  has_many :tags, dependent: :destroy

  validates :title, presence: true
  scope :incomplete, -> { where(completed: [false, nil]) }
end
