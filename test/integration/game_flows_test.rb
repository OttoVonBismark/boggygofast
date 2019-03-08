require 'test_helper'

class GameFlowsTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)

    @sonic = games(:sonic)
  end

  # Index testing
  test 'games index as admin including edit and delete links' do
    log_in_as(@admin)
    get games_path
    assert_template 'games/index'
    game_collection = Game.all
    game_collection.each do |game|
      assert_select 'a[href=?]', speedruns_path(game.slug), text: game.name
      assert_select 'a[href=?]', game_path(game), text: "| Game Info"
      assert_select 'a[href=?]', runcats_path(game.slug), text: "| Categories"
      unless @admin.admin?
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
    log_in_as(@non_admin)
    get games_path
    assert_template 'games/index'
    game_collection = Game.all
    game_collection.each do |game|
      assert_select 'a[href=?]', speedruns_path(game.slug), text: game.name
      assert_select 'a[href=?]', game_path(game), text: "| Game Info"
      assert_select 'a[href=?]', runcats_path(game.slug), text: "| Categories"
    end
    assert_no_difference 'Game.count' do
      delete game_path(@sonic)
    end
  end
end
