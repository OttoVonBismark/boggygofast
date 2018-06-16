require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
  end

  # Index testing
  test 'index as admin including pagination and delete links' do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
        assert_select 'a[href=?]', user_path(user), text: user.name
        unless user == @admin
            assert_select 'a[href=?]', user_path(user), text: 'delete'
        end
    end
    assert_difference 'User.count', -1 do
        delete user_path(@non_admin)
    end
  end

  test 'index as non-admin' do
    log_in_as(@non_admin)
    get users_path
    assert_template 'users/index'
    assert_select 'a', text: 'delete', count: 0
  end

  # Edit tests
  test 'unsuccessful edit' do
    log_in_as(@admin)
    get edit_user_path(@admin)
    assert_template 'users/edit'
    patch user_path(@admin), params: {user: {name: "", email: "foo@invalid", password: "foo", password_confirmation: "bar"}}
    assert_template 'users/edit'
  end

  test 'successful edit with friendly forwarding' do
    get edit_user_path(@admin)
    log_in_as(@admin)
    assert_redirected_to edit_user_url(@admin)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@admin), params: {user: {name: name, email: email, password: "", password_confirmation: ""}}
    refute flash.empty?
    assert_redirected_to @admin
    @admin.reload
    assert_equal name, @admin.name
    assert_equal email, @admin.email
  end

  # Login tests
  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: {session: {email: "", password: ""}}
    assert_template 'sessions/new'
    refute flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: {session: {email: @admin.email, password: 'password'}}
    assert is_logged_in?
    assert_redirected_to @admin
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@admin)
    delete logout_path
    refute is_logged_in?
    assert_redirected_to root_url
    # Simulate a user clicking logout in a second window. (Multi-session bug #1)
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,       count: 0
    assert_select "a[href=?]", user_path(@admin),  count: 0
  end

  test "login with remembering" do
    log_in_as(@admin, remember_me: '1')
    refute_empty cookies['remember_token']
  end

  test "login without remembering" do
    # Log in to set the cookie.
    log_in_as(@admin, remember_me: '1')
    # Log in again to verify that the cookie is deleted.
    log_in_as(@admin, remember_me: '0')
    assert_empty cookies['remember_token']
  end

  # User profile testing
  test "profile display" do
    get user_path(@admin)
    assert_template 'users/show'
    assert_select 'title', full_title(@admin.name)
    assert_select 'h1', text: @admin.name
    assert_select 'h1>img.gravatar'
  end

  # User signup tests
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
        post users_path, params: {user: {name: "", email: "user@invalid", password: "foo", password_confirmation: "bar"}}
    end
    assert_template 'users/new'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
        post users_path, params: {user: {name: "Example User", email: "user@example.com", password: "password", password_confirmation: "password"}}
    end
    user = assigns(:user)
    log_in_as(user)
    assert is_logged_in?
  end
end
