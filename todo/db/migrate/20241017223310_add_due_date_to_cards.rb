class AddDueDateToCards < ActiveRecord::Migration[7.2]
  def change
    add_column :cards, :due_date, :datetime
  end
end
