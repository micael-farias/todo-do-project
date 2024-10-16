class CreateBoards < ActiveRecord::Migration[7.2]
  def change
    create_table :boards do |t|
      t.string :title
      t.references :user, foreign_key: true, null: false
      t.timestamps
    end
  end
end
