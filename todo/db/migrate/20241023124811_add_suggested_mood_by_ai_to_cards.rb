class AddSuggestedMoodByAiToCards < ActiveRecord::Migration[7.2]
  def change
    add_reference :cards, :mood_suggested_by_ai, foreign_key: { to_table: :moods }
  end
end
