# app/models/card.rb
class Card < ApplicationRecord
  has_many :tags, dependent: :destroy
  belongs_to :board_item
  acts_as_list scope: :board_item
  belongs_to :mood, optional: true # Torna o humor opcional, se necessário
  accepts_nested_attributes_for :tags, allow_destroy: true, reject_if: :all_blank
  belongs_to :user, optional: true # Se aplicável

  validates :title, presence: true
  scope :incomplete, -> { where(completed: [false, nil]) }
end
