class AddShowRecentBoardsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :show_recent_boards, :boolean
  end
end
