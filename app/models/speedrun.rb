class Speedrun < ApplicationRecord

  belongs_to :game
  belongs_to :user # This is mostly symbolic. Don't CREATE speedruns via @user. Do it with @game instead. Read and Destroy are fine though.
  has_one :runcat

  validates_presence_of :date_finished, :run_time

end
