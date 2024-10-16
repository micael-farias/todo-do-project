class CreateBoardItemTags < ActiveRecord::Migration[7.2]
  def change
    create_table :board_item_tags do |t|
      t.references :board_item, foreign_key: true, null: false # Relacionamento com board_items
      t.string :name
      t.timestamps
    end
  end
end
