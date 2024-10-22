class AddShowPopularBoardsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :show_popular_boards, :boolean
  end
end
