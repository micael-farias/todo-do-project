class AddDefaultValuesToShowFields < ActiveRecord::Migration[6.0]
  def change
    change_column_default :users, :show_recent_boards, true
    change_column_default :users, :show_popular_boards, true
    change_column_default :users, :show_daily_board, true
    change_column_default :users, :show_card_priority, true
    change_column_default :users, :show_card_due_date, true
    change_column_default :users, :show_card_mood, true
  end
end
