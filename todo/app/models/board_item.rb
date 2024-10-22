class BoardItem < ApplicationRecord
  # Associations
  belongs_to :board
  has_many :cards, dependent: :destroy

  # Validations
  validates :name, presence: true
end
