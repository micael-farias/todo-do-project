class AddShowPriorityToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :show_priority, :boolean
  end
end
