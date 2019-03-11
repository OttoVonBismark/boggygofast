require 'test_helper'

class GamesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @sonic = games(:sonic)
    @metroid = games(:metroid)
    @ori = games(:ori)

    @admin_user = users(:michael)
    @user = users(:archer)
  end

  # CRUD tests
  # Create
  test "successful add game as admin" do
    log_in_as(@admin_user)
    get new_game_path
    assert_template 'games/new'
    name = "Ori and the Will of the Wisps"
    slug = "OrI_WotW"
    info = "The sequel to Ori and the Blind Forest"
    assert_difference 'Game.count', 1 do
      post games_path, params: {game: {name: name, slug: slug, info: info}}
    end
    assert_redirected_to games_path
    follow_redirect!
    refute flash.empty?
  end

  test "unsuccessful add game as admin" do
    log_in_as(@admin_user)
    get new_game_path
    assert_template 'games/new'
    name = "" # I played in the desert on a game with no name.
    slug = "🦊" # Don't slug foxes. They are cute.
    info = false # False information may lead to penalties including fines and jail time.
    assert_no_difference 'Game.count' do
      post games_path, params: {game: {name: name, slug: slug, info: info}}
    end
  end

  # Read
  # This also tests to make sure my begin/rescue block works, since current_user.admin? (for the delete link) doesn't exist unless the viewer logs in,
  # causing a NoMethod Error and NilClass exception otherwise.
  test "should get games index" do
    get games_index_path
    assert_response :success
    assert_select "title", "List of Games | BoggyGoFast Speedrun Archive"
  end

  test "should get game show page" do
    get game_path(@sonic)
    assert_response :success
    assert_select "title", "Sonic Mania | BoggyGoFast Speedrun Archive"
  end

  # Admin gets
  test "admins should get new game page" do
    log_in_as(@admin_user)
    assert @admin_user.admin?
    get new_game_path
    assert_response :success
    assert_select "title", "Create a New Game | BoggyGoFast Speedrun Archive"
  end

  test "admins should get edit game page" do
    log_in_as(@admin_user)
    assert @admin_user.admin?
    get edit_game_path(@sonic)
    assert_response :success
    assert_select "title", "Edit Sonic Mania | BoggyGoFast Speedrun Archive"
  end
  
  # Non-Admin redirects
  test "non-admins should get redirected from new game page" do
    log_in_as(@user)
    refute @user.admin?
    get new_game_path
    assert_redirected_to root_url
  end

  test "non-admins should get redirected from edit game page" do
    log_in_as(@user)
    refute @user.admin?
    get edit_game_path(@sonic.slug)
    assert_redirected_to root_url
  end

  test "anonymous should get redirected from new game page" do
    get new_game_path
    assert_redirected_to login_url
  end

  test "anonymous should get redirected from edit game page" do
    get edit_game_path(@sonic.slug)
    assert_redirected_to login_url
  end

  # Update
  test 'successful games edit with slug formatting' do
    log_in_as(@admin_user)
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
  
  test "unsuccessful games edit" do
    log_in_as(@admin_user)
    get edit_game_path(@sonic)
    assert_template 'games/edit'
    patch game_path(@sonic), params: {game: {name: "", slug: ""}}
    assert_template 'games/edit'
    refute_equal @sonic.name, ""
    refute_equal @sonic.slug, ""
  end

  # Delete
  test "admins can delete games" do
    log_in_as(@admin_user)
    assert_difference 'Game.count', -1 do
      delete game_path(@sonic)
    end
  end

  test "non-admins cannot delete games" do
    log_in_as(@user)
    assert_no_difference 'Game.count' do
      delete game_path(@sonic)
    end
  end

  test "anonymous cannot delete games" do
    assert_no_difference 'Game.count' do
      delete game_path(@sonic)
    end
  end
end
