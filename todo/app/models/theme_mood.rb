class ThemeMood < ApplicationRecord
  # Associations
  belongs_to :mood_category
  belongs_to :mood
  has_many :theme_mood_messages, dependent: :destroy

  # Validations
  validates :image_url, presence: true
  validates :message, presence: true
end
