class UserPreference < ApplicationRecord
    belongs_to :user
  
    validates :show_recent_boards, inclusion: { in: [true, false] }
    validates :show_popular_boards, inclusion: { in: [true, false] }
    validates :show_daily_board, inclusion: { in: [true, false] }
    validates :show_card_priority, inclusion: { in: [true, false] }
    validates :show_card_due_date, inclusion: { in: [true, false] }
    validates :show_card_mood, inclusion: { in: [true, false] }
    validates :show_form_after_create_card, inclusion: { in: [true, false] }
  end
  