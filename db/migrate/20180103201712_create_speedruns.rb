class CreateSpeedruns < ActiveRecord::Migration[5.1]
  def change
    create_table :speedruns do |t|
      t.references :game, foreign_key: true, column: :slug, on_delete: :cascade, on_update: :cascade
      t.references :user, foreign_key: true, column: :name, on_delete: :cascade, on_update: :cascade
      t.date :date_finished, null: false
      t.string :category, null: false
      t.time :run_time, null: false
      t.text :run_notes
      t.boolean :used_amiibo, default: false
      t.boolean :is_valid, default: false

      t.timestamps
    end
  end
end