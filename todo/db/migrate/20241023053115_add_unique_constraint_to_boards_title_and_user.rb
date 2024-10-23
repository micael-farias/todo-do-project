class AddUniqueConstraintToBoardsTitleAndUser < ActiveRecord::Migration[6.0]
  def change
    add_index :boards, [:title, :user_id], unique: true
  end
end
