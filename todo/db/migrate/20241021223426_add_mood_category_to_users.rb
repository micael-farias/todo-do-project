class AddMoodCategoryToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :mood_category_id, :bigint
  end
end
