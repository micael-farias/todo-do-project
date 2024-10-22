class AddShowMoodToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :show_card_mood, :boolean
  end
end
