class CreateParameters < ActiveRecord::Migration[7.2]
  def change
    create_table :parameters do |t|
      t.string :name
      t.references :user, foreign_key: true, null: false # Relacionamento com users
      t.text :content
      t.string :salt_key
      t.timestamps
    end
  end
end
