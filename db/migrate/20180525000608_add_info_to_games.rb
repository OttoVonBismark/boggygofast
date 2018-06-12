class AddInfoToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :info, :text, default: "A very cool game indeed!"
  end
end
