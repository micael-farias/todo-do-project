class AddActiveToUserMoods < ActiveRecord::Migration[7.2]
  def change
    add_column :user_moods, :active, :boolean
  end
end
