class Speedrun < ApplicationRecord

  belongs_to :game
  belongs_to :user

  validates_presence_of :date_finished, :runcat_id, :run_time

end
