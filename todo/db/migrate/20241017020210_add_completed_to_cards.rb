class AddCompletedToCards < ActiveRecord::Migration[7.2]
  def change
    add_column :cards, :completed, :boolean
  end
end
