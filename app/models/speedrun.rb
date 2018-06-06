class Speedrun < ApplicationRecord

  include ActiveRelationExtensions
  
  require 'date'
  require 'active_support/core_ext/string'

  belongs_to :game
  belongs_to :user # This is mostly symbolic. Don't CREATE speedruns via @user. Do it with @game instead. Read and Destroy are fine though.

  validates_presence_of :date_finished
  validates :run_time_h, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 99}
  validates :run_time_m, :run_time_s, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 59}

  def runner_name
    runner = User.find_by_id(self.user_id)
    runner_name = runner.name
  end

  def run_time
    rt_h = self.run_time_h.to_s
    
    if self.run_time_m < 10
      rt_m = "0" + self.run_time_m.to_s
    else
      rt_m = self.run_time_m.to_s
    end

    if self.run_time_s < 10
      rt_s = "0" + self.run_time_s.to_s
    else
      rt_s = self.run_time_s.to_s
    end

    run_time = rt_h + ":" + rt_m + ":" + rt_s
  end

end
