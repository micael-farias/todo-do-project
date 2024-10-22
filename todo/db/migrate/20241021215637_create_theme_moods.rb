class CreateThemeMoods < ActiveRecord::Migration[7.2]
  def change
    create_table :theme_moods do |t|
      t.references :mood_category, null: false, foreign_key: true
      t.references :mood, null: false, foreign_key: true
      t.string :image_url
      t.text :message

      t.timestamps
    end
  end
end
