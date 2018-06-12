class AdjustRuntimeFormatInSpeedruns < ActiveRecord::Migration[5.2]
  def change
    remove_column :speedruns, :run_time
    add_column :speedruns, :run_time_h, :integer, null: false, default: 99
    add_column :speedruns, :run_time_m, :integer, null: false, default: 59
    add_column :speedruns, :run_time_s, :integer, null: false, default: 59
  end
end
