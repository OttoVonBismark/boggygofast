class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end
    add_index :games, [:slug]
  end
end
