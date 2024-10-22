class AddImageUrlToMoodCategories < ActiveRecord::Migration[7.2]
  def change
    add_column :mood_categories, :image_url, :string
  end
end
