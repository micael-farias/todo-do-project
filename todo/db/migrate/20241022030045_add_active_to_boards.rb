class AddActiveToBoards < ActiveRecord::Migration[7.2]
  def change
    add_column :boards, :active, :boolean
  end
end
