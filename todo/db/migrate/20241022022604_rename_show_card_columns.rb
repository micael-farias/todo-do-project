class RenameShowCardColumns < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :show_priority, :show_card_priority
    rename_column :users, :show_due_date, :show_card_due_date
    rename_column :users, :show_mood, :show_card_mood
  end
end
