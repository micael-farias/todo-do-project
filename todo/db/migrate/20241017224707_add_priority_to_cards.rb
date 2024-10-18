class AddPriorityToCards < ActiveRecord::Migration[7.2]
  def change
    add_column :cards, :priority, :integer
  end
end
