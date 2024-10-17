class AddPositionToCards < ActiveRecord::Migration[7.2]
  def change
    add_column :cards, :position, :integer
  end
end
