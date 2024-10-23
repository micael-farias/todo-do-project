class AddDailyToBoards < ActiveRecord::Migration[6.0]
  def change
    add_column :boards, :daily, :boolean, default: false
  end
end
