class AddPhraseToMoodCategories < ActiveRecord::Migration[7.2]
  def change
    add_column :mood_categories, :phrase, :string
  end
end
