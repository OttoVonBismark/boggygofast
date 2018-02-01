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
      run_time: "01:00:40", 
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

  test "run_time should not be empty" do
    @speedrun.run_time = nil
    refute @speedrun.valid?
  end

  test "run_notes can be empty and still valid" do
    @speedrun.run_notes = nil
    assert @speedrun.valid?
  end

end
