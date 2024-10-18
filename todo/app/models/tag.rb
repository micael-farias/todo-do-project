# app/models/tag.rb

class Tag < ApplicationRecord
  belongs_to :card

  validates :name, presence: true, uniqueness: { scope: :card_id }
end
