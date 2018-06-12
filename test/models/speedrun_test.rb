require 'test_helper'

class SpeedrunTest < ActiveSupport::TestCase
  def setup
    @game = games(:ori)
    @user = users(:michael)
    @runcat = runcats(:ori_anyperc)
    @speedrun = @game.speedruns.build(
      :user_id => @user.id, 
      date_finished: "2018-01-10", 
      :runcat_id => @runcat.id, 
      run_time_h: 1,
      run_time_m: 0,
      run_time_s: 40, 
      run_notes: "Notetastic", 
      is_valid: true
    )
  end

  test "speedrun should be valid" do
    assert @speedrun.valid?
  end

  test "date_finished should not be empty" do
    @speedrun.date_finished = nil
    refute @speedrun.valid?
  end

  test "run_time_h should not be empty" do
    @speedrun.run_time_h = nil
    refute @speedrun.valid?
  end

  test "run_time_m should not be empty" do
    @speedrun.run_time_m = nil
    refute @speedrun.valid?
  end

  test "run_time_s should not be empty" do
    @speedrun.run_time_s = nil
    refute @speedrun.valid?
  end

  # TODO: Test run_time_x validations to make sure values are within range.

  test "run_notes can be empty and still valid" do
    @speedrun.run_notes = nil
    assert @speedrun.valid?
  end

end
