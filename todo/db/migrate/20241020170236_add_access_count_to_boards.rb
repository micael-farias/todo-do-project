class AddAccessCountToBoards < ActiveRecord::Migration[7.2]
  def change
    add_column :boards, :access_count, :integer
  end
end
