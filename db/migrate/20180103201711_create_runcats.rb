class CreateRuncats < ActiveRecord::Migration[5.1]
  # The name of this migration has been altered so that it takes place prior to Speedrun's generation for simplicity.
  def change
    create_table :runcats do |t|
      t.string :category, null: false
      t.text :rules, null: false
      t.boolean :amiibo_allowed, default: false
      t.references :game, foreign_key: true, on_delete: :cascade, on_update: :cascade

      t.timestamps
    end
    add_index :runcats, :category
  end
end
