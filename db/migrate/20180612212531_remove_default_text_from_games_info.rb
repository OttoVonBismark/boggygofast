class RemoveDefaultTextFromGamesInfo < ActiveRecord::Migration[5.2]
  def change
    remove_column :games, :info
    add_column :games, :info, :text
  end
end
