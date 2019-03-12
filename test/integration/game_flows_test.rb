require 'test_helper'

class GameFlowsTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @admin_user = users(:michael)
    @user = users(:archer)

    @sonic = games(:sonic)
  end

  # Index testing
  test 'games index as admin including edit and delete links' do
    log_in_as(@admin_user)
    get games_path
    assert_template 'games/index'
    assert_response :success
    assert_select 'title', full_title("List of Games")
    game_collection = Game.all
    game_collection.each do |game|
      assert_select 'a[href=?]', speedruns_path(game.slug), text: game.name
      assert_select 'a[href=?]', game_path(game), text: "| Game Info"
      assert_select 'a[href=?]', runcats_path(game.slug), text: "| Categories"
      unless @admin_user.admin?
        assert_select 'a[href=?]', new_game_runcat_path(game.slug), text: "| New Category"
        assert_select 'a[href=?]', edit_game_path(game.slug), text: "| Edit Game"
        assert_select 'a[href=?]', game_path(game.slug), text: "| Delete"
      end
    end
    assert_select 'a[href=?]', new_game_path, text: "Create New Game"
    assert_difference 'Game.count', -1 do
      delete game_path(@sonic)
    end
  end

  test 'games index as non-admin' do
    log_in_as(@user)
    get games_path
    assert_template 'games/index'
    assert_response :success
    assert_select 'title', full_title("List of Games")
    game_collection = Game.all
    game_collection.each do |game|
      assert_select 'a[href=?]', speedruns_path(game.slug), text: game.name
      assert_select 'a[href=?]', game_path(game), text: "| Game Info"
      assert_select 'a[href=?]', runcats_path(game.slug), text: "| Categories"
      assert_select 'a', {count: 0, text: "| New Category"}
      assert_select 'a', {count: 0, text: "| Edit Game"}
      assert_select 'a', {count: 0, text: "| Delete"}
    end
    assert_no_difference 'Game.count' do
      delete game_path(@sonic)
    end
  end

  test 'games index as anonymous' do
    get games_path
    assert_template 'games/index'
    assert_response :success
    assert_select 'title', full_title("List of Games")
    game_collection = Game.all
    game_collection.each do |game|
      assert_select 'a[href=?]', speedruns_path(game.slug), text: game.name
      assert_select 'a[href=?]', game_path(game), text: "| Game Info"
      assert_select 'a[href=?]', runcats_path(game.slug), text: "| Categories"
      assert_select 'a', {count: 0, text: "| New Category"}
      assert_select 'a', {count: 0, text: "| Edit Game"}
      assert_select 'a', {count: 0, text: "| Delete"}
    end
    assert_no_difference 'Game.count' do
      delete game_path(@sonic)
    end
  end

  # Show Page Tests
  # There are no conditional changes for whomever sees this page.
  test 'games show as anyone' do
    get game_path(@sonic.slug)
    assert_template 'games/show'
    assert_response :success
    assert_select 'title', full_title(@sonic.name)
    assert_select 'h1', text: @sonic.name
    assert_select 'p', text: @sonic.info
    assert_select 'a[href=?]', runcats_path(@sonic.slug)
    assert_select 'a[href=?]', new_game_speedrun_path(@sonic.slug)
  end

  # We already test for what happens when non-admins/anon try to access new/edit, so we're skipping that here.
  # New Page Tests
  test 'games new as admin' do
    log_in_as(@admin_user)
    get new_game_path
    assert_template 'games/new'
    assert_response :success
    assert_select 'title', full_title("Create a New Game")
    assert_select 'h1', text: "Create a New Game"
    assert_select 'form', count: 1
    assert_select 'input[type=submit]', count: 1, value: "Create Game"
  end

  # Edit Page Tests
  test 'games edit as admin' do
    log_in_as(@admin_user)
    get edit_game_path(@sonic)
    assert_template 'games/edit'
    assert_response :success
    assert_select 'title', full_title("Edit " + @sonic.name)
    assert_select 'h1', text: "Edit " + @sonic.name
    assert_select 'form', count: 1
    assert_select 'input[type=submit]', count: 1, value: "Update Game"
  end
end
