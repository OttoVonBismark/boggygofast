require 'test_helper'

class SpeedrunFlowsTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)

    @sonic = games(:sonic)
    @castlevania = games(:castlevania)

    @speedrun = speedruns(:sonic_1)
  end

  # Sanity checks... probably shouldn't be here, but screw it.
  test "user id and speedrun.user_id should match" do
    assert_equal @admin.id, @speedrun.user_id
  end

  test "game id and speedrun.game_id should match" do
    assert_equal @sonic.id, @speedrun.game_id
  end

  # Index tests
  test "should get index for games with runs" do
    get speedruns_path(@sonic.slug)
    assert_template
    assert_equal 2, @sonic.speedruns.count
    assert_select 'h1', text: "Runs for " + @sonic.name, count: 1
    assert_select 'a[href=?]', new_game_speedrun_path, text: "here!", count: 1
    runcat_collection = @sonic.runcats.all
    speedrun_collection = @sonic.speedruns.all
    runcat_collection.each do |runcat|
      assert_select 'h4', text: runcat.category, count: 1
      assert_select 'table', count: 2
      speedrun_collection.each do |speedrun|
        assert_select 'td', count: 20 # The table/td values are grand totals, not per-loop.
      end
    end
  end

  test "should get index for games with no runs" do
    get speedruns_path(@castlevania.slug)
    assert_template
    assert_equal 0, @castlevania.speedruns.count
    assert_select 'h3', count: 1
    assert_select 'a[href=?]', new_game_speedrun_path, text: "submit a run!", count: 1
  end

  # Edit page tests
  # This test will be made more robust (check for page elements) later
  test "successful speedrun edit as admin" do
    log_in_as(@admin)
    get edit_speedrun_path(@speedrun)
    assert_template 'speedruns/edit'
    game_name = @speedrun.game.name # You don't want to touch this
    user_name = @speedrun.user.name # Or this
    is_valid = true
    date_finished = '2018-01-04'
    runcat_id = 1
    run_time_h = 01
    run_time_m = 42
    run_time_s = 11
    run_notes = "I got edited successfully!"
    patch speedrun_path(@speedrun), params: {speedrun: {game_name: game_name, user_name: user_name, is_valid: is_valid, date_finished: date_finished, runcat_id: runcat_id, 
        run_time_h: run_time_h, run_time_m: run_time_m, run_time_s: run_time_s, run_notes: run_notes}}
    refute flash.empty?
    @speedrun.reload
    assert_redirected_to @speedrun
    assert_equal game_name, @speedrun.game.name
    assert_equal user_name, @speedrun.user.name
    assert_equal is_valid, @speedrun.is_valid
    assert_equal date_finished.to_date, @speedrun.date_finished
    assert_equal runcat_id, @speedrun.runcat_id
    assert_equal run_time_h, @speedrun.run_time_h
    assert_equal run_time_m, @speedrun.run_time_m
    assert_equal run_time_s, @speedrun.run_time_s
    assert_equal run_notes, @speedrun.run_notes
  end

  test "unsuccessful speedrun edit as admin" do
    log_in_as(@admin)
    get edit_speedrun_path(@speedrun)
    assert_template 'speedruns/edit'
    game_name = "Spelunky" # YOU TOUCHED THE PARENTS! HOW COULD YOU!?
    user_name = "Mister NoParents" # OH THE INHUMANITY!
    is_valid = "" # You hear the Rust compiler screaming in the distance...
    date_finished = "" # Ah yes, nil. A fine day that was.
    runcat_id = "A spoon" # Haha! That's not a number, silly!
    run_time_h = 99 # invalid unless < 10 by design
    run_time_m = 61 # that's too many minutes!
    run_time_s = 23445 # what the hell even is this?
    run_notes = true # The best remarks for your run. "Yes."
    patch speedrun_path(@speedrun), params: {speedrun: {game_name: game_name,
      user_name: user_name, is_valid: is_valid, date_finished: date_finished, 
      runcat_id: runcat_id, run_time_h: run_time_h, run_time_m: run_time_m,
      run_time_s: run_time_s, run_notes: run_notes}}
    @speedrun.reload
    refute_equal game_name, @speedrun.game.name
    refute_equal user_name, @speedrun.user.name
    refute_equal is_valid, @speedrun.is_valid
    refute_equal date_finished.to_date, @speedrun.date_finished
    refute_equal runcat_id, @speedrun.runcat_id
    refute_equal run_time_h, @speedrun.run_time_h
    refute_equal run_time_m, @speedrun.run_time_m
    refute_equal run_time_s, @speedrun.run_time_s
    refute_equal run_notes, @speedrun.run_notes
  end
end
