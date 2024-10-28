class CreateUserPreferences < ActiveRecord::Migration[7.2]
  def change
    create_table :user_preferences do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :show_recent_boards, default: true, null: false
      t.boolean :show_popular_boards, default: true, null: false
      t.boolean :show_daily_board, default: true, null: false
      t.boolean :show_card_priority, default: true, null: false
      t.boolean :show_card_due_date, default: true, null: false
      t.boolean :show_card_mood, default: true, null: false
      t.boolean :show_form_after_create_card, default: true, null: false

      t.timestamps
    end
  end
end
