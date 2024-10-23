class Board < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :board_items, -> { order(:position) }, dependent: :destroy
  has_many :cards, through: :board_items

  # Nested Attributes
  accepts_nested_attributes_for :board_items, allow_destroy: true

  # Validations
  validates :title, presence: true
  validates :daily, uniqueness: { scope: :user_id }, if: :daily?

  # Scopes
  scope :active, -> { where(active: true) }
  scope :daily, -> { where(daily: true) }

  # Instance Methods
  def daily_board?
    daily
  end
end
