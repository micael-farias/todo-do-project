class AddShowFormAfterCreateCardToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :show_form_after_create_card, :boolean, default: true
  end
end
