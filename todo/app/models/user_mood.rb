class UserMood < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :mood
end
