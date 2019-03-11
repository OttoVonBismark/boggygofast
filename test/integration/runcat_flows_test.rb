require 'test_helper'

class RuncatFlowsTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @admin_user = users(:michael)
    @user =  users(:archer)

    @sonic = games(:sonic)
    @castlevania = games(:castlevania)

    @speedrun = speedruns(:sonic_1)
    @runcat = runcats(:sonic_anyperc)
  end

  # Sanity checks that should not be here but are because I'm in charge.
  test "runcat ID and speedrun.runcat_id should be equal" do
    assert_equal @runcat.id, @speedrun.runcat_id
  end

  test "runcat.game_id and game ID should be equal" do
    assert_equal @sonic.id, @runcat.game_id
  end

  # Index tests
  test "admins should get runcats index for game with categories and admin-only links" do
    log_in_as(@admin_user)
    get runcats_path(@sonic.slug)
    assert_template 'runcats/index'
    assert_response :success
    assert_select 'title', full_title("Categories for " + @sonic.name)
    assert_select 'h1', text: "Categories for " + @sonic.name, count: 1
    runcat_collection = @sonic.runcats.all
    runcat_collection.each do |runcat|
      assert_select 'h3', text: runcat.category
      assert_select 'p', text: runcat.rules
      assert_select 'a[href=?]', edit_runcat_path(@runcat.id), text: "Edit |"
      assert_select 'a[href=?]', runcat_path(@runcat.id), method: :delete, text: "Delete"
    end
    assert_select 'a[href=?]', new_game_runcat_path(@sonic.slug), text: "here", count: 1
  end

  test 'users should get runcats index for games with categories' do
    log_in_as(@user)
    get runcats_path(@sonic.slug)
    assert_template 'runcats/index'
    assert_response :success
    assert_select 'title', full_title("Categories for " + @sonic.name) 
    assert_select 'h1', text: "Categories for " + @sonic.name, count: 1
    runcat_collection = @sonic.runcats.all
    runcat_collection.each do |runcat|
      assert_select 'h3', text: runcat.category
      assert_select 'p', text: runcat.rules
      assert_select 'a[href=?]', edit_runcat_path(@runcat.id), count: 0
      assert_select 'a[href=?]', runcat_path(@runcat.id), method: :delete, text: "Delete", count: 0
    end
    assert_select 'a[href=?]', new_game_runcat_path(@sonic.slug), text: "here", count: 0
  end

  test "anonymous should get runcats index for game with categories" do
    get runcats_path(@sonic.slug)
    assert_template 'runcats/index'
    assert_response :success
    assert_select 'title', full_title("Categories for " + @sonic.name) 
    assert_select 'h1', text: "Categories for " + @sonic.name, count: 1
    runcat_collection = @sonic.runcats.all
    runcat_collection.each do |runcat|
      assert_select 'h3', text: runcat.category
      assert_select 'p', text: runcat.rules
      assert_select 'a[href=?]', edit_runcat_path(@runcat.id), count: 0
      assert_select 'a[href=?]', runcat_path(@runcat.id), method: :delete, text: "Delete", count: 0
    end
    assert_select 'a[href=?]', new_game_runcat_path(@sonic.slug), text: "here", count: 0
  end

  test "admins should get runcats index for game with no categories with create new link" do
    log_in_as(@admin_user)
    get runcats_path(@castlevania.slug)
    assert_template 'runcats/index'
    assert_response :success
    assert_select 'title', full_title("Categories for " + @castlevania.name)
    assert_select 'h1', text: "Categories for " + @castlevania.name, count: 1
    assert_select 'a[href=?]', new_game_runcat_path, count: 1
    assert_select 'p', text: "No categories to list.", count: 1
  end

  test "users should get runcats index for game with no categories" do
    log_in_as(@user)
    get runcats_path(@castlevania.slug)
    assert_template 'runcats/index'
    assert_response :success
    assert_select 'title', full_title("Categories for " + @castlevania.name)
    assert_select 'h1', text: "Categories for " + @castlevania.name, count: 1
    assert_select 'a[href=?]', new_game_runcat_path, count: 0
    assert_select 'p', text: "No categories to list.", count: 1
  end

  test "anonymous should get runcats index for game with no categories" do
    get runcats_path(@castlevania.slug)
    assert_template 'runcats/index'
    assert_response :success
    assert_select 'title', full_title("Categories for " + @castlevania.name)
    assert_select 'h1', text: "Categories for " + @castlevania.name, count: 1
    assert_select 'a[href=?]', new_game_runcat_path, count: 0
    assert_select 'p', text: "No categories to list.", count: 1
  end

  # Show Page Tests
end
