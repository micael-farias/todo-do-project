class AddIndexesToBoardsAndCards < ActiveRecord::Migration[7.2]
  def change
    add_index :boards, :active
    add_index :boards, :last_access
    add_index :cards, :completed
    add_index :cards, :due_date
    add_index :cards, :priority
  end
end
