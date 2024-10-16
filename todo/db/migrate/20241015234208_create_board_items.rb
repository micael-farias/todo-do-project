class CreateBoardItems < ActiveRecord::Migration[7.2]
  def change
    create_table :board_items do |t|
      t.references :board, foreign_key: true, null: false # Relacionamento com boards
      t.string :name
      t.integer :priority, default: 0, null: false # ENUM equivalent
      t.datetime :due_date
      t.timestamps
    end
  end
end
