class AddMoodIdToUsers < ActiveRecord::Migration[7.2]
  def change
    add_reference :users, :mood, null: true, foreign_key: true
  end
end
