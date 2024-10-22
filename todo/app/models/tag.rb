class Tag < ApplicationRecord
  # Associations
  belongs_to :card

  # Validations
  validates :name, presence: true, uniqueness: { scope: :card_id }
end
