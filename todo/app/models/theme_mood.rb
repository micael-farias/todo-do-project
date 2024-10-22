class ThemeMood < ApplicationRecord
  belongs_to :mood_category
  belongs_to :mood
  has_many :theme_mood_messages, dependent: :destroy

  validates :image_url, presence: true
  validates :message, presence: true
end
