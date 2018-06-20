require 'test_helper'

class SpeedrunsControllerTest < ActionDispatch::IntegrationTest
    def setup
        @game = games(:sonic)
        @runcat = runcats(:sonic_anyperc)
        @speedrun = speedruns(:sonic_1)

        @user = users(:michael)
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
end
