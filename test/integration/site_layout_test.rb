require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:archer)
    @admin_user = users(:michael)
  end

  test "layout links as guest" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", games_index_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", new_user_path
  end

  test "layout links as user" do
    log_in_as(@user)
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", games_index_path
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", adminland_path, count: 0
  end

  test "layout links as admin" do
    log_in_as(@admin_user)
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", games_index_path
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", edit_user_path(@admin_user)
    assert_select "a[href=?]", user_path(@admin_user)
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", adminland_path
  end
end
