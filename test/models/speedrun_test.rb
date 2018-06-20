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

  # Testing run time boundaries
  test "run_time_h should not be greater than 9" do
    @speedrun.run_time_h = 10
    refute @speedrun.valid?
  end

  test "run_time_m should not be greater than 59" do
    @speedrun.run_time_m = 60
    refute @speedrun.valid?
  end

  test "run_time_s should not be greater than 59" do
    @speedrun.run_time_s = 60
    refute @speedrun.valid?
  end

  # Test run_time formatter
  test "run_time formatter should output correctly" do
    @run_time_formatted = @speedrun.run_time
    assert_equal @run_time_formatted, "1:00:40"
  end

  test "run_notes can be empty and still valid" do
    @speedrun.run_notes = nil
    assert @speedrun.valid?
  end

end
