class ChangeDefaultForActiveInBoards < ActiveRecord::Migration[7.0]
  def change
    change_column_default :boards, :active, from: nil, to: true
  end
end
