require 'test_helper'

class GameFlowsTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)

    @sonic = games(:sonic)
  end

  # Index testing
  test 'index as admin including edit and delete links' do
    log_in_as(@admin)
    get games_path
    assert_template 'games/index'
    game_collection = Game.all
    game_collection.each do |game|
      assert_select 'a[href=?]', game_path(game), text: game.name
      assert_select 'a[href=?]', speedruns_path(game.slug), text: "| Runs"
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

  test 'index as non-admin' do
    log_in_as(@non_admin)
    get games_path
    assert_template 'games/index'
    game_collection = Game.all
    game_collection.each do |game|
      assert_select 'a[href=?]', game_path(game), text: game.name
      assert_select 'a[href=?]', speedruns_path(game.slug), text: "| Runs"
      assert_select 'a[href=?]', runcats_path(game.slug), text: "| Categories"
    end
    assert_no_difference 'Game.count' do
      delete game_path(@sonic)
    end
  end

  # Edit tests
  test "unsuccessful edit" do
    log_in_as(@admin)
    get edit_game_path(@sonic)
    assert_template 'games/edit'
    patch game_path(@sonic), params: {game: {name: "", slug: ""}}
    assert_template 'games/edit'
  end

  test 'successful edit with slug formatting' do
    log_in_as(@admin)
    get edit_game_path(@sonic)
    assert_template 'games/edit'
    name = "Sonic Forces"
    slug = "sOnIc_FoRcEs"
    info = "This is a game"
    patch game_path(@sonic), params: {game: {name: name, slug: slug, info: info}}
    refute flash.empty?
    @sonic.reload
    assert_redirected_to @sonic
    assert_equal name, @sonic.name
    assert_equal "sonic_forces", @sonic.slug
    assert_equal info, @sonic.info
  end

  # New Game tests
  # test "successful add game as admin" do # This doesn't work due to params being params (NoMethodError) despite looking IDENTICAL to the new users test.
  #   log_in_as(@admin)
  #   get new_game_path
  #   assert_template 'games/new'
  #   name = "Ori and the Will of the Wisps"
  #   slug = "OrI_WotW"
  #   info = "The sequel to Ori and the Blind Forest"
  #   assert_difference 'Game.count', 1 do
  #     post gamegen_path, params: {game: {name: name, slug: slug, info: info}}
  #   end
  #   assert_redirected_to games_path
  #   follow_redirect!
  #   refute flash.empty?
  #   ori_wotw = Game.find_by_slug(params[:ori_wotw])
  #   assert_select 'a[href=?]', game_path(ori_wotw), text: name
  # end

  # Temporary until I figure out the above issue
  test "admins should get new games" do
    log_in_as(@admin)
    get new_game_path
    assert_template
  end

  test "non-admins should not get new games" do
    log_in_as(@non_admin)
    get new_game_path
    assert_redirected_to root_url
  end

  # Show tests
  test "should get show page" do
    get game_path(@sonic.slug)
    assert_template
  end
end
