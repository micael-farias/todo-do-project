class AddLastAccessToBoards < ActiveRecord::Migration[7.2]
  def change
    add_column :boards, :last_access, :datetime
  end
end
