class MoodCategory < ApplicationRecord
  # Associations
  has_many :theme_moods, dependent: :destroy
  has_many :moods, through: :theme_moods

  # Validations
  validates :name, presence: true, uniqueness: true
end
