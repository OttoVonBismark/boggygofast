class RemoveAmiiboSupportFromGames < ActiveRecord::Migration[5.1]
  # In which I realized the inclusion of runcats completely negates the usefulness of amiibo columns.
  def change
    remove_column :games, :amiibo_support
    remove_column :runcats, :amiibo_allowed
    remove_column :speedruns, :used_amiibo
  end
end
