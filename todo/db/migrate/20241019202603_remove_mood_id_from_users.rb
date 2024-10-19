class RemoveMoodIdFromUsers < ActiveRecord::Migration[7.2]
  def change
    remove_column :users, :mood_id, :bigint
  end
end
