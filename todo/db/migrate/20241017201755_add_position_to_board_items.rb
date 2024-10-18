class AddPositionToBoardItems < ActiveRecord::Migration[7.2]
  def change
    add_column :board_items, :position, :integer
  end
end
