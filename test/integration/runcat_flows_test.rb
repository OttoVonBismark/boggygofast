require 'test_helper'

class RuncatFlowsTest < ActionDispatch::IntegrationTest
  # This could get interesting due to this model being a child...

  def setup
    @admin = users(:michael)
    @non_admin =  users(:archer)

    @sonic = games(:sonic)
    @castlevania = games(:castlevania)

    @speedrun = speedruns(:sonic_1)
    @runcat = runcats(:sonic_anyperc)
  end

  # Sanity checks that should not be here but are because I'm in charge.
  test "runcat ID and speedrun.runcat_id should be equal" do
    assert_equal @runcat.id, @speedrun.runcat_id
  end

  test "runcat.game_id and game ID should be equal" do
    assert_equal @sonic.id, @runcat.game_id
  end

  # Index tests
  test "should get runcats index for game with categories" do
    get runcats_path(@sonic.slug)
    assert_template
    assert_select 'h1', text: "Categories for " + @sonic.name, count: 1
    runcat_collection = @sonic.runcats.all
    runcat_collection.each do |runcat|
      assert_select 'h3', text: runcat.category
      assert_select 'p', text: runcat.rules
    end
    assert_select 'a[href=?]', new_game_runcat_path(@sonic.slug), text: "here", count: 0
  end

  test "should get runcats index for game with categories as admin with admin-only links" do
    log_in_as(@admin)
    get runcats_path(@sonic.slug)
    assert_template
    assert_select 'h1', text: "Categories for " + @sonic.name, count: 1
    runcat_collection = @sonic.runcats.all
    runcat_collection.each do |runcat|
      assert_select 'h3', text: runcat.category
      assert_select 'p', text: runcat.rules
    end
    assert_select 'a[href=?]', new_game_runcat_path(@sonic.slug), text: "here", count: 1
  end

  test "should get runcats index for game with no categories" do
    get runcats_path(@castlevania.slug)
    assert_template
    assert_select 'p', text: "No categories to list.", count: 1
  end

  # Show Runcat tests
  test "everyone should get runcat show page" do
    get runcat_path(@runcat.id)
    assert_template
  end

  # New Runcats tests
  test "admins should get new runcat page" do
    log_in_as(@admin)
    get new_game_runcat_path(@sonic.slug)
    assert_template
  end

  test "non-admins should not get runcat page" do
    log_in_as(@non_admin)
    get new_game_runcat_path(@sonic.slug)
    assert_redirected_to root_url
  end

  test "runcat should reject invalid input" do
    log_in_as(@admin)
    get new_game_runcat_path(@castlevania.slug)
    assert_template
    category = "" # Cannot be blank
    rules = false # NO RULES NO MASTERS!
    assert_no_difference 'Runcat.count' do
      post runcats_path, params: {runcat: {category: category, rules: rules}}
    end
  end

  test "runcat should accept valid input" do
    log_in_as(@admin)
    get new_game_runcat_path(@castlevania.slug)
    assert_template
    category = "glitchless"
    rules = "Beat the game without using glitches"
    assert_difference 'Runcat.count', 1 do
      post runcats_path, params: {runcat: {category: category, rules: rules}}
    end
  end

  # Edit Runcat tests
  test "admins should get runcat edit page" do
    log_in_as(@admin)
    get edit_runcat_path(@runcat.id)
    assert_response :success
    assert_template
  end

  test "non-admins should not get runcat edit page" do
    log_in_as(@non_admin)
    get edit_runcat_path(@runcat.id)
    assert_redirected_to root_url
  end

  test "successful runcat edit" do
    log_in_as(@admin)
    get edit_runcat_path(@runcat.id)
    assert_response :success
    assert_template
    category = "glitchless"
    rules = "Beat the game without using glitches"
    patch runcat_path(@runcat.id), params: {runcat: {category: category, rules: rules}}
    @runcat.reload
    assert_equal category, @runcat.category
    assert_equal rules, @runcat.rules
  end

  test "unsuccessful runcat edit" do
    log_in_as(@admin)
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

  # Delete Runcat tests
  test "admins can delete runcats" do
    log_in_as(@admin)
    assert_difference "Runcat.count", -1 do
      delete runcats_path(@sonic.slug, @runcat.id)
    end
  end

  test "non-admins cannot delete runcats" do
    log_in_as(@non_admin)
    assert_no_difference "Runcat.count" do
      delete runcats_path(@sonic.slug, @runcat.id)
    end
  end

end
