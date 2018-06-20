require 'test_helper'

class RuncatFlowsTest < ActionDispatch::IntegrationTest
  # This could get interesting due to this model being a child...

  def setup
    @admin = users(:michael)
    @non_admin =  users(:archer)

    @sonic = games(:sonic)
    @castlevania = games(:castlevania)

    @speedrun = speedruns(:sonic_1)
    @runcatorama = runcats(:sonic_anyperc)
  end

  # Sanity checks that should not be here but are because I'm in charge.
  test "runcat ID and speedrun.runcat_id should be equal" do
    assert_equal @runcatorama.id, @speedrun.runcat_id
  end

  test "runcat.game_id and game ID should be equal" do
    assert_equal @sonic.id, @runcatorama.game_id
  end

  # Index tests
  test "should get index for game with categories" do
    get runcats_path(@sonic.slug)
    assert_template
    assert_select 'h1', text: "Categories for " + @sonic.name, count: 1
    runcat_collection = @sonic.runcats.all
    runcat_collection.each do |runcat|
      assert_select 'h3', text: runcat.category
      assert_select 'p', text: runcat.rules
    end
    assert_select 'a[href=?]', new_game_runcat_path(@sonic.slug), text: "here", count: 0
  end

  test "should get index for game with categories as admin with admin-only links" do
    log_in_as(@admin)
    get runcats_path(@sonic.slug)
    assert_template
    assert_select 'h1', text: "Categories for " + @sonic.name, count: 1
    runcat_collection = @sonic.runcats.all
    runcat_collection.each do |runcat|
      assert_select 'h3', text: runcat.category
      assert_select 'p', text: runcat.rules
    end
    assert_select 'a[href=?]', new_game_runcat_path(@sonic.slug), text: "here", count: 1
  end

  test "should get index for game with no categories" do
    get runcats_path(@castlevania.slug)
    assert_template
    assert_select 'p', text: "No categories to list.", count: 1
  end

  # New Runcats tests
  test "admins should get new runcat page" do
    log_in_as(@admin)
    get new_game_runcat_path(@sonic.slug)
    assert_template
  end

  test "non-admins should not get runcat page" do
    log_in_as(@non_admin)
    get new_game_runcat_path(@sonic.slug)
    assert_redirected_to root_url
  end

  # Here's where I'd do integration testing for admins creating new runcats... if params was a thing that worked. Oh well.
end
