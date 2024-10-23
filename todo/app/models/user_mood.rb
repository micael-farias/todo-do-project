class UserMood < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :mood

  scope :today, -> { where(updated_at: Time.current.beginning_of_day..Time.current.end_of_day) }
  scope :active, -> { where(active: true) }
end
