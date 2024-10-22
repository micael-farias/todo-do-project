class AddShowDueDateToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :show_due_date, :boolean
  end
end
