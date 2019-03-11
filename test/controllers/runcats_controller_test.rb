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

    # CRUD Tests
    # Create
    test "runcat should accept valid input" do
        log_in_as(@admin_user)
        get new_game_runcat_path(@sonic.slug)
        assert_template
        category = "glitchless"
        rules = "Beat the game without using glitches"
        assert_difference 'Runcat.count', 1 do
        post runcats_path, params: {runcat: {category: category, rules: rules}}
        end
    end

    test "runcat should reject invalid input" do
        log_in_as(@admin_user)
        get new_game_runcat_path(@sonic.slug)
        assert_template
        category = "" # Cannot be blank
        rules = false # NO RULES NO MASTERS!
        assert_no_difference 'Runcat.count' do
        post runcats_path, params: {runcat: {category: category, rules: rules}}
        end
    end

    # Read
    # General page gets
    test "everyone should get runcats index" do
        get runcats_path(@sonic.slug)
        assert_response :success
        assert_select "title", "Categories for Sonic Mania | BoggyGoFast Speedrun Archive"
    end

    test "everyone should get runcat show page" do
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

    test "anonymous should get redirected from new runcat page" do
        get new_game_runcat_path(@sonic.slug)
        assert_redirected_to login_url
    end

    test "anonymous should get redirected from edit runcat page" do
        get edit_runcat_path(@runcat.id)
        assert_redirected_to login_url
    end

    # Update
    test "successful runcat edit" do
        log_in_as(@admin_user)
        get edit_runcat_path(@runcat.id)
        assert_response :success
        assert_template
        category = "glitchless"
        rules = "Beat the game without using glitches"
        patch runcat_path(@runcat.id), params: {runcat: {category: category, rules: rules}}
        refute flash.empty?
        @runcat.reload
        assert_equal category, @runcat.category
        assert_equal rules, @runcat.rules
    end

    test "unsuccessful runcat edit" do
        log_in_as(@admin_user)
        get edit_runcat_path(@runcat.id)
        assert_response :success
        assert_template
        category = "" # Let's be as nebulous about the run as humanly possible.
        rules = 3 # I hear it's a magical number.
        patch runcat_path(@runcat.id), params: {runcat: {category: category, rules: rules}}
        @runcat.reload
        refute_equal category, @runcat.category
        refute_equal rules, @runcat.rules
    end

    # Delete
    # Delete Runcat tests
    test "admins can delete runcats" do
        log_in_as(@admin_user)
        assert_difference "Runcat.count", -1 do
        delete runcats_path(@sonic.slug, @runcat.id)
        end
    end

    test "non-admins cannot delete runcats" do
        log_in_as(@user)
        assert_no_difference "Runcat.count" do
        delete runcats_path(@sonic.slug, @runcat.id)
        end
    end

    test "anonymous cannot delete runcats" do
        assert_no_difference 'Runcat.count' do
            delete runcats_path(@sonic.slug, @runcat.id)
        end
    end
end
