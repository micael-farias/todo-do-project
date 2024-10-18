class AddCompletedAtToCards < ActiveRecord::Migration[7.2]
  def change
    add_column :cards, :completed_at, :datetime
  end
end
