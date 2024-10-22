class AddShowDailyBoardToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :show_daily_board, :boolean
  end
end
