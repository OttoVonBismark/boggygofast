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
  test "admins runcats index integration with categories and admin-only links" do
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

  test 'users runcats index integration with categories' do
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

  test "anonymous runcats index integration with categories" do
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

  test "admins runcats index integrations with no categories with create new link" do
    log_in_as(@admin_user)
    get runcats_path(@castlevania.slug)
    assert_template 'runcats/index'
    assert_response :success
    assert_select 'title', full_title("Categories for " + @castlevania.name)
    assert_select 'h1', text: "Categories for " + @castlevania.name, count: 1
    assert_select 'a[href=?]', new_game_runcat_path, count: 1
    assert_select 'p', text: "No categories to list.", count: 1
  end

  test "users runcats index integrations with no categories" do
    log_in_as(@user)
    get runcats_path(@castlevania.slug)
    assert_template 'runcats/index'
    assert_response :success
    assert_select 'title', full_title("Categories for " + @castlevania.name)
    assert_select 'h1', text: "Categories for " + @castlevania.name, count: 1
    assert_select 'a[href=?]', new_game_runcat_path, count: 0
    assert_select 'p', text: "No categories to list.", count: 1
  end

  test "anonymous runcats index integrations with no categories" do
    get runcats_path(@castlevania.slug)
    assert_template 'runcats/index'
    assert_response :success
    assert_select 'title', full_title("Categories for " + @castlevania.name)
    assert_select 'h1', text: "Categories for " + @castlevania.name, count: 1
    assert_select 'a[href=?]', new_game_runcat_path, count: 0
    assert_select 'p', text: "No categories to list.", count: 1
  end

  # Show Page Tests
  test 'admin show page integration with edit and delete links' do
    log_in_as(@admin_user)
    get runcat_path(@runcat.id)
    assert_template 'runcats/show'
    assert_response :success
    assert_select 'title', full_title(@runcat.game.name + " - " + @runcat.category)
    assert_select 'h1', "The " + @runcat.category + " category for " + @runcat.game.name, count: 1
    assert_select 'a[href=?]', edit_runcat_path(@runcat.id), text: "Edit |", count: 1
    assert_select 'a[href=?]', runcat_path(@runcat.id), method: :delete, text: "Delete", count: 1
    assert_select 'p', text: "Rules: " + @runcat.rules
  end

  test 'users show page integration' do
    log_in_as(@user)
    get runcat_path(@runcat.id)
    assert_template 'runcats/show'
    assert_response :success
    assert_select 'title', full_title(@runcat.game.name + " - " + @runcat.category)
    assert_select 'h1', "The " + @runcat.category + " category for " + @runcat.game.name, count: 1
    assert_select 'a[href=?]', edit_runcat_path(@runcat.id), text: "Edit |", count: 0
    assert_select 'a[href=?]', runcat_path(@runcat.id), method: :delete, text: "Delete", count: 0
    assert_select 'p', text: "Rules: " + @runcat.rules
  end

  test 'anonymous show page integration' do
    get runcat_path(@runcat.id)
    assert_template 'runcats/show'
    assert_response :success
    assert_select 'title', full_title(@runcat.game.name + " - " + @runcat.category)
    assert_select 'h1', "The " + @runcat.category + " category for " + @runcat.game.name, count: 1
    assert_select 'a[href=?]', edit_runcat_path(@runcat.id), text: "Edit |", count: 0
    assert_select 'a[href=?]', runcat_path(@runcat.id), method: :delete, text: "Delete", count: 0
    assert_select 'p', text: "Rules: " + @runcat.rules
  end

  # New Page Tests (Only testing as admin, since controller tests already account for non-admins/anon)
  test 'admins new page integration' do
    log_in_as(@admin_user)
    get new_game_runcat_path(@sonic.slug)
    assert_template 'runcats/new'
    assert_response :success
    assert_select 'title', full_title("Create a New Category for " + @sonic.name)
    assert_select 'h1', text: "Create a New Category", count: 1
    assert_select 'form', count: 1
    assert_select 'input[type=submit]', value: "Add Category", count: 1
  end

  # Edit Page Tests
  test 'admins edit page integration' do
    log_in_as(@admin_user)
    get edit_runcat_path(@runcat.id)
    assert_template 'runcats/edit'
    assert_response :success
    assert_select 'title', full_title("Edit the " + @runcat.game.name + " Category, " + @runcat.category)
    assert_select 'h1', text: "Editing the " + @runcat.category + " category for " + @runcat.game.name
    assert_select 'form', count: 1
    assert_select 'input[type=submit]', value: "Update Category", count: 1
  end
end
