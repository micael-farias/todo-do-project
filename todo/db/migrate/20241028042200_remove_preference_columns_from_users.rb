class RemovePreferenceColumnsFromUsers < ActiveRecord::Migration[7.2]
  def change
    remove_column :users, :show_recent_boards, :boolean
    remove_column :users, :show_popular_boards, :boolean
    remove_column :users, :show_daily_board, :boolean
    remove_column :users, :show_card_priority, :boolean
    remove_column :users, :show_card_due_date, :boolean
    remove_column :users, :show_card_mood, :boolean
    remove_column :users, :show_form_after_create_card, :boolean
  end
end
