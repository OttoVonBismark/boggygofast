class Speedrun < ApplicationRecord
  require 'date'
  require 'active_support/core_ext/string'

  belongs_to :game
  belongs_to :user # This is mostly symbolic. Don't CREATE speedruns via @user. Do it with @game instead. Read and Destroy are fine though.
  has_one :runcat

  validates_presence_of :date_finished
  validates :run_time_h, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 99}
  validates :run_time_m, :run_time_s, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 59}

end
