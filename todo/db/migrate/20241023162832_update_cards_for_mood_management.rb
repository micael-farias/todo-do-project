class UpdateCardsForMoodManagement < ActiveRecord::Migration[7.0]
  def change
    # Remover colunas mood_id e mood_suggested_by_ai_id
    remove_column :cards, :mood_suggested_by_ai_id, :bigint

    # Adicionar nova coluna mood_source
    add_column :cards, :mood_source, :string
  end
end
