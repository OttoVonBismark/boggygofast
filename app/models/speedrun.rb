class Speedrun < ApplicationRecord

  belongs_to :game
  belongs_to :user

  validates_presence_of :date_finished, :category, :run_time
end
