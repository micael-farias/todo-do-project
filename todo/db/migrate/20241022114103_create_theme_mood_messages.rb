class CreateThemeMoodMessages < ActiveRecord::Migration[7.2]
    def change
      create_table :theme_mood_messages do |t|
        t.bigint :theme_mood_id, null: false
        t.text :message, null: false
        t.timestamps
      end
  
      add_index :theme_mood_messages, :theme_mood_id
      add_foreign_key :theme_mood_messages, :theme_moods, column: :theme_mood_id
    end
  end
  