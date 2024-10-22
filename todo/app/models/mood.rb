class Mood < ApplicationRecord
    has_many :theme_moods, dependent: :destroy
    has_many :mood_categories, through: :theme_moods
    has_many :cards, dependent: :nullify
    has_many :user_moods, dependent: :destroy
    has_many :users, through: :user_moods
    
    validates :name, presence: true, uniqueness: true
end
