require 'test_helper'

class SpeedrunsControllerTest < ActionDispatch::IntegrationTest
    def setup
        @game = games(:sonic)
        @speedrun = speedruns(:sonic_1)

        @admin_user = users(:michael)
        @user = users(:archer)
    end

    # CRUD Tests
    # Create

    # Read
    # Show Get Tests
    test 'anyone should get speedruns show' do
        get speedrun_path(@speedrun.id)
        assert_template 'speedruns/show'
        assert_response :success
    end

    # Index Get Tests
    test "anyone should get speedruns index" do
        get speedruns_path(@game.slug)
        assert_template 'speedruns/index'
        assert_response :success
        assert_select "title", "Runs for Sonic Mania | BoggyGoFast Speedrun Archive"
    end

    # New Speedrun Get Tests
    test "users should get new speedruns" do
        log_in_as @user
        get new_game_speedrun_path(@game.slug)
        assert_template 'speedruns/new'
        assert_response :success
        assert_select "title", "Submit a New Run for Sonic Mania | BoggyGoFast Speedrun Archive"
    end

    test "anonymous should get redirected from new speedruns" do
        get new_game_speedrun_path(@game.slug)
        assert_redirected_to login_url
    end

    # Editing Page Gets
    test "admins should get speedruns edit page" do
        log_in_as @admin_user
        get edit_speedrun_path(@speedrun.id)
        assert_template 'speedruns/edit'
        assert_response :success
    end

    test "users should not get speedruns edit page" do
        log_in_as @user
        get edit_speedrun_path(@speedrun.id)
        assert_redirected_to root_url
    end

    test 'anonymous should not get speedruns edit page' do
        get edit_speedrun_path(@speedrun.id)
        assert_redirected_to login_url
    end

    # Update
    test "successful speedrun edit as admin" do
        log_in_as(@admin_user)
        get edit_speedrun_path(@speedrun)
        assert_template 'speedruns/edit'
        assert_response :success
        game_name = @speedrun.game.name # You don't want to touch this
        user_name = @speedrun.user.name # Or this
        is_valid = true
        date_finished = '2018-01-04'
        runcat_id = 1
        run_time_h = 01
        run_time_m = 42
        run_time_s = 11
        run_notes = "I got edited successfully!"
        patch speedrun_path(@speedrun), params: {speedrun: {game_name: game_name, 
            user_name: user_name, is_valid: is_valid, date_finished: date_finished, 
            runcat_id: runcat_id, run_time_h: run_time_h, run_time_m: run_time_m, 
            run_time_s: run_time_s, run_notes: run_notes}}
        refute flash.empty?
        @speedrun.reload
        assert_redirected_to @speedrun
        assert_equal game_name, @speedrun.game.name
        assert_equal user_name, @speedrun.user.name
        assert_equal is_valid, @speedrun.is_valid
        assert_equal date_finished.to_date, @speedrun.date_finished
        assert_equal runcat_id, @speedrun.runcat_id
        assert_equal run_time_h, @speedrun.run_time_h
        assert_equal run_time_m, @speedrun.run_time_m
        assert_equal run_time_s, @speedrun.run_time_s
        assert_equal run_notes, @speedrun.run_notes
    end

    test "unsuccessful speedrun edit as admin" do
        log_in_as(@admin_user)
        get edit_speedrun_path(@speedrun)
        assert_template 'speedruns/edit'
        assert_response :success
        game_name = "Spelunky" # YOU TOUCHED THE PARENTS! HOW COULD YOU!?
        user_name = "Mister NoParents" # OH THE INHUMANITY!
        is_valid = "" # You hear the Rust compiler screaming in the distance...
        date_finished = "" # Ah yes, nil. A fine day that was.
        runcat_id = "A spoon" # Haha! That's not a number, silly!
        run_time_h = 99 # invalid unless < 10 by design
        run_time_m = 61 # that's too many minutes!
        run_time_s = 23445 # what the hell even is this?
        run_notes = true # The best remarks for your run. "Yes."
        patch speedrun_path(@speedrun), params: {speedrun: {game_name: game_name,
            user_name: user_name, is_valid: is_valid, date_finished: date_finished, 
            runcat_id: runcat_id, run_time_h: run_time_h, run_time_m: run_time_m,
            run_time_s: run_time_s, run_notes: run_notes}}
        @speedrun.reload
        refute_equal game_name, @speedrun.game.name
        refute_equal user_name, @speedrun.user.name
        refute_equal is_valid, @speedrun.is_valid
        refute_equal date_finished.to_date, @speedrun.date_finished
        refute_equal runcat_id, @speedrun.runcat_id
        refute_equal run_time_h, @speedrun.run_time_h
        refute_equal run_time_m, @speedrun.run_time_m
        refute_equal run_time_s, @speedrun.run_time_s
        refute_equal run_notes, @speedrun.run_notes
    end

    # Delete
    test 'admins can delete speedruns' do
        log_in_as(@admin_user)
        assert_difference 'Speedrun.count', -1 do
            delete speedrun_path(@speedrun)
        end
    end

    test 'users cannot delete speedruns' do
        log_in_as(@user)
        assert_no_difference 'Speedrun.count' do
            delete speedrun_path(@speedrun)
        end
    end

    test 'anonymous cannot delete speedruns' do
        assert_no_difference 'Speedrun.count' do
            delete speedrun_path(@speedrun)
        end
    end
end
