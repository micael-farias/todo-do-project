class AddPreviousBoardItemIdToCards < ActiveRecord::Migration[7.2]
  def change
    add_column :cards, :previous_board_item_id, :integer
  end
end
