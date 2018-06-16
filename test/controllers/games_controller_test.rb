require 'test_helper'

class GamesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @sonic = games(:sonic)
    @metroid = games(:metroid)
    @ori = games(:ori)

    @user = users(:michael)
    @other_user = users(:archer)
  end

  # This also tests to make sure my begin/rescue block works, since current_user.admin? (for the delete link) doesn't exist unless the viewer logs in,
  # causing a NoMethod Error and NilClass exception otherwise.
  test "should get index" do
    get games_index_path
    assert_response :success
    assert_select "title", "List of Games | BoggyGoFast Speedrun Archive"
  end

  test "should get new game page for admin users" do
    log_in_as(@user)
    assert @user.admin?
    get new_game_path
    assert_response :success
    assert_select "title", "Create a New Game | BoggyGoFast Speedrun Archive"
  end

  test "should get show page" do
    get game_path(@sonic)
    assert_response :success
  end
  
  test "should redirect non-admins from new game page" do
    log_in_as(@other_user)
    refute @other_user.admin?
    get new_game_path
    assert_redirected_to root_url
  end

  test "should redirect non-admins from edit game page" do
    log_in_as(@other_user)
    refute @other_user.admin?
    get edit_game_path(@sonic.slug)
    assert_redirected_to root_url
  end

end
