require 'test_helper'

class SpeedrunFlowsTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @admin_user = users(:michael)
    @user = users(:archer)

    @sonic = games(:sonic)
    @castlevania = games(:castlevania)

    @speedrun = speedruns(:sonic_1)
    @runcat = runcats(:sonic_anyperc)
  end

  # Sanity checks... probably shouldn't be here, but screw it.
  test "user id and speedrun.user_id should match" do
    assert_equal @admin_user.id, @speedrun.user_id
  end

  test "game id and speedrun.game_id should match" do
    assert_equal @sonic.id, @speedrun.game_id
  end

  # Show Tests
  test 'speedruns show integration as admin' do
    log_in_as(@admin_user)
    get speedrun_path(@speedrun.id)
    assert_template 'speedruns/show'
    assert_response :success
    assert_select 'title', full_title(@speedrun.game.name + " " + 
      @runcat.category + " in " + @speedrun.run_time + " by " + 
      @speedrun.user.name)
    assert_select 'h1', text: @speedrun.game.name + " " + @runcat.category + " in " + @speedrun.run_time + " by " + @speedrun.user.name
    assert_select 'a[href=?]', edit_speedrun_path(@speedrun.id), text: "Edit |", count: 1
    assert_select 'a[href=?]', speedrun_path(@speedrun.id), text: "Delete", count: 1
    assert_select 'table', count: 1
  end

  test 'speedruns show integration as user' do
    log_in_as(@user)
    get speedrun_path(@speedrun.id)
    assert_template 'speedruns/show'
    assert_response :success
    assert_select 'title', full_title(@speedrun.game.name + " " + 
      @runcat.category + " in " + @speedrun.run_time + " by " + 
      @speedrun.user.name)
    assert_select 'h1', text: @speedrun.game.name + " " + @runcat.category + " in " + @speedrun.run_time + " by " + @speedrun.user.name
    assert_select 'a[href=?]', edit_speedrun_path(@speedrun.id), text: "Edit |", count: 0
    assert_select 'a[href=?]', speedrun_path(@speedrun.id), text: "Delete", count: 0
    assert_select 'table', count: 1
  end

  test 'speedruns show integration as anonymous' do
    get speedrun_path(@speedrun.id)
    assert_template 'speedruns/show'
    assert_response :success
    assert_select 'title', full_title(@speedrun.game.name + " " + 
      @runcat.category + " in " + @speedrun.run_time + " by " + 
      @speedrun.user.name)
    assert_select 'h1', text: @speedrun.game.name + " " + @runcat.category + " in " + @speedrun.run_time + " by " + @speedrun.user.name
    assert_select 'a[href=?]', edit_speedrun_path(@speedrun.id), text: "Edit |", count: 0
    assert_select 'a[href=?]', speedrun_path(@speedrun.id), text: "Delete", count: 0
    assert_select 'table', count: 1
  end

  # Index Tests
  test "speedrun index integration as anyone with runs" do
    get speedruns_path(@sonic.slug)
    assert_template 'speedruns/index'
    assert_response :success
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

  test "speedrun index integration as anyone with no runs" do
    get speedruns_path(@castlevania.slug)
    assert_template 'speedruns/index'
    assert_response :success
    assert_equal 0, @castlevania.speedruns.count
    assert_select 'h3', count: 1
    assert_select 'a[href=?]', new_game_speedrun_path, text: "submit a run!", count: 1
  end

  # New Tests
  # Anonymous tests need not be created, as anon cannot access this page
  # This behavior is already tested in the controller
  test 'speedrun new integration as admin with categories present' do
    log_in_as(@admin_user)
    get new_game_speedrun_path(@sonic.slug)
    assert_template 'speedruns/new'
    assert_response :success
    assert_select 'title', full_title("Submit a New Run for " + @sonic.name)
    assert_select 'h1', text: "Submit a New Run for " + @sonic.name
    assert_select 'form', count: 1
    assert_select 'input[type=submit]', value: "Submit Speedrun"
  end

  test 'speedrun new integration as user with categories present' do
    log_in_as(@user)
    get new_game_speedrun_path(@sonic.slug)
    assert_template 'speedruns/new'
    assert_response :success
    assert_select 'title', full_title("Submit a New Run for " + @sonic.name)
    assert_select 'h1', text: "Submit a New Run for " + @sonic.name
    assert_select 'form', count: 1
    assert_select 'input[type=submit]', value: "Submit Speedrun"
  end

  test 'speedrun new integration as admin with categories not present' do
    log_in_as(@admin_user)
    get new_game_speedrun_path(@castlevania.slug)
    assert_template 'speedruns/new'
    assert_response :success
    assert_equal 0, @castlevania.runcats.count
    assert_select 'title', full_title("Submit a New Run for " + @castlevania.name)
    assert_select 'h1', text: "Submit a New Run for " + @castlevania.name
    assert_select 'a[href=?]', new_game_runcat_path(@castlevania.slug), count: 1
    assert_select 'form', count: 0
  end

  test 'speedrun new integration as user with categories not present' do
    log_in_as(@user)
    get new_game_speedrun_path(@castlevania.slug)
    assert_template 'speedruns/new'
    assert_response :success
    assert_equal 0, @castlevania.runcats.count
    assert_select 'title', full_title("Submit a New Run for " + @castlevania.name)
    assert_select 'h1', text: "Submit a New Run for " + @castlevania.name
    assert_select 'a[href=?]', new_game_runcat_path(@castlevania.slug), count: 0
    assert_select 'form', count: 0
  end

  # Edit Tests
  # Admins only
  test 'speedruns edit integration as admin' do
    log_in_as(@admin_user)
    get edit_speedrun_path(@speedrun.id)
    assert_template 'speedruns/edit'
    assert_response :success
    assert_select 'title', full_title("Edit Speedrun for " + @speedrun.game.name)
    assert_select 'h1', text: "Edit Speedrun for " + @speedrun.game.name
    assert_select 'form', count: 1
    assert_select 'input[type=submit]', value: "Update Speedrun"
  end
end
