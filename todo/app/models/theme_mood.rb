class ThemeMood < ApplicationRecord
  belongs_to :mood_category
  belongs_to :mood

  validates :image_url, presence: true
  validates :message, presence: true
end
