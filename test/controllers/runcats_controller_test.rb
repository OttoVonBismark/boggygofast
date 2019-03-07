require 'test_helper'

class RuncatsControllerTest < ActionDispatch::IntegrationTest
    def setup
        # Games
        @sonic = games(:sonic)

        # Runcat
        @runcat = runcats(:ori_anyperc)

        # Users
        @admin_user = users(:michael)
        @user = users(:archer)
    end

    # General page gets
    test "should get runcats index" do
        get runcats_path(@sonic.slug)
        assert_response :success
        assert_select "title", "Categories for Sonic Mania | BoggyGoFast Speedrun Archive"
    end

    test "should get runcat show page" do
        get runcat_path(@runcat.id)
        assert_response :success
        assert_select "title", "Ori and the Blind Forest - any% | BoggyGoFast Speedrun Archive"
    end

    # Admin page gets
    test "admins should get new runcats" do
        log_in_as(@admin_user)
        assert @admin_user.admin?
        get new_game_runcat_path(@sonic.slug)
        assert_response :success
        assert_select "title", "Create a New Category for Sonic Mania | BoggyGoFast Speedrun Archive"
    end

    test "admins should get edit runcats" do
        log_in_as(@admin_user)
        assert @admin_user.admin?
        get edit_runcat_path(@runcat.id)
        assert_response :success
    end

    # Non-Admin redirects
    test "non-admins should get redirected from new runcat page" do
        log_in_as(@user)
        refute @user.admin?
        get new_game_runcat_path(@sonic.slug)
        assert_redirected_to root_url
    end

    test "non-admins should get redirected from edit runcat page" do
        log_in_as(@user)
        refute @user.admin?
        get edit_runcat_path(@runcat.id)
        assert_redirected_to root_url
    end
end
