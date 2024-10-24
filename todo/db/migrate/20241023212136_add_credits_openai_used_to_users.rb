class AddCreditsOpenaiUsedToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :credits_openai_used, :integer
  end
end
