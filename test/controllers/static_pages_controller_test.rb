require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  
  test "everyone should get home" do
    get root_path
    assert_response :success
    assert_select "title", "BoggyGoFast Speedrun Archive"
  end

  test "everyone should get about" do
    get about_path
    assert_response :success
    assert_select "title", "What are we about? | BoggyGoFast Speedrun Archive"
  end

end
