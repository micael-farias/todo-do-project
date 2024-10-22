class Board < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :board_items, dependent: :destroy
  has_many :cards, through: :board_items

  # Nested Attributes
  accepts_nested_attributes_for :board_items, allow_destroy: true

  # Validations
  validates :title, presence: true

  # Scopes
  scope :active, -> { where(active: true) }
  scope :daily, -> { where("title LIKE ?", "%Board Diário%") }

  # Instance Methods
  def daily_board?
    title.include?('Board Diário')
  end
end
