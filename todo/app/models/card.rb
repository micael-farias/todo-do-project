class Card < ApplicationRecord
  # Associations
  belongs_to :board_item
  belongs_to :mood, optional: true
  belongs_to :user, optional: true
  has_many :tags, dependent: :destroy

  # Nested Attributes
  accepts_nested_attributes_for :tags, allow_destroy: true, reject_if: :all_blank

  # Acts as list for positioning
  acts_as_list scope: :board_item

  # Callbacks
  before_save :set_completion_status
  after_create :create_daily_board_if_first_card

  # Validations
  validates :title, presence: true

  # Scopes
  scope :completed, -> { where(completed: true) }
  scope :not_completed, -> { where(completed: false) }
  scope :due_between, ->(start_date, end_date) { where(due_date: start_date..end_date) }
  scope :ordered, -> { order(priority: :desc) }
  scope :active, -> { not_completed }
  scope :due_soon, ->(today) { not_completed.due_between(today, today + 3.days) }
  scope :by_mood_ids, ->(mood_ids) { where(mood_id: mood_ids) }
  scope :by_priority, -> { order(priority: :desc) }
  scope :random_order, -> { order("RANDOM()") }

  # Instance Methods
  def in_last_column?
    board_item.board.board_items.order(:position).last.id == board_item_id
  end

  private

  # Set the completion status based on column position
  def set_completion_status
    if board_item_id_changed?
      if in_last_column?
        self.completed = true
        self.completed_at = Utils::DateService.today
      else
        self.completed = false
        self.completed_at = nil
      end
    end
  end

  def create_daily_board_if_first_card
    user = board_item.board.user
    unless user.boards.daily.exists?
      Boards::DailyBoardService.new(user).create_daily_board
    end
  end
  
end
