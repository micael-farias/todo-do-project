class MoodCategory < ApplicationRecord
    has_many :theme_moods, dependent: :destroy
    has_many :moods, through: :theme_moods
  
    validates :name, presence: true, uniqueness: true
  end
  