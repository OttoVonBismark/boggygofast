require 'test_helper'

class RuncatsControllerTest < ActionDispatch::IntegrationTest
    def setup
        # Games
        @sonic = games(:sonic)
        @metroid = games(:metroid)

        # Runcats
        @sonic_anyperc = runcats(:sonic_anyperc)
        @sonic_100perc = runcats(:sonic_100perc)
        @metroid_anyperc = runcats(:metroid_anyperc)
        @metroid_100perc = runcats(:metroid_100perc)

        # Users
        @user = users(:michael)
        @other_user = users(:archer)
    end

    # General page gets
    test "should get index" do
        get runcats_path(@sonic.slug)
        assert_response :success
        assert_select "title", "Categories for Sonic Mania | BoggyGoFast Speedrun Archive"
    end

    # Admin page gets
    test "should get new for admins" do
        log_in_as(@user)
        assert @user.admin?
        get new_game_runcat_path(@sonic.slug)
        assert_response :success
        assert_select "title", "Create a New Category for Sonic Mania | BoggyGoFast Speedrun Archive"
    end

    # Non-Admin redirects
    test "should redirect non-admins from new runcat page" do
        log_in_as(@other_user)
        refute @other_user.admin?
        get new_game_runcat_path(@sonic.slug)
        assert_redirected_to root_url
    end
end
