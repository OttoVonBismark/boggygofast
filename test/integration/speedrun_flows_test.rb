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

  # New Page tests
  test "should get new" do
    get new_game_speedrun_path(@sonic.slug)
    assert_template
  end
end
