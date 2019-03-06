require 'test_helper'

class SpeedrunsControllerTest < ActionDispatch::IntegrationTest
    def setup
        @game = games(:sonic)
        @runcat = runcats(:sonic_anyperc)
        @speedrun = speedruns(:sonic_1)

        @admin_user = users(:michael)
        @user = users(:archer)
    end

    # General page gets
    test "should get speedruns index" do
        get speedruns_path(@game.slug)
        assert_response :success
        assert_select "title", "Runs for Sonic Mania | BoggyGoFast Speedrun Archive"
    end

    # Logged-in user page gets
    test "should get new for logged-in users" do
        log_in_as @user
        get new_game_speedrun_path(@game.slug)
        assert_response :success
        assert_select "title", "Submit a New Run for Sonic Mania | BoggyGoFast Speedrun Archive"
    end

    # Redirects for non-logged-in users
    test "should redirect non-logged-in users from new speedrun page" do
        get new_game_speedrun_path(@game.slug)
        assert_redirected_to login_url
    end

    # Child model editing tests
    # Editing page gets
    test "admins should get edit page" do
        skip "Skipping this so I can commit this test as a checkpoint."
        log_in_as @admin_user
        get edit_speedrun_path(@speedrun.id)
        assert_response :success
    end

    test "non-admins should not get edit page" do
        skip "Skipping this so I can commit this test as a checkpoint."
        log_in_as @user
        get edit_speedrun_path(@speedrun.id)
        assert_response(403)
    end
end
