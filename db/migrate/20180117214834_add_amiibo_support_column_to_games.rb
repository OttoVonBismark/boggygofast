class AddAmiiboSupportColumnToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :amiibo_support, :boolean, default: false
  end
end
