class AddMoodToCards < ActiveRecord::Migration[7.2]
  def change
    add_reference :cards, :mood, null: true, foreign_key: true
  end
end
