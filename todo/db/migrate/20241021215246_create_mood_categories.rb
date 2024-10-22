class CreateMoodCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :mood_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
