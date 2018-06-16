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

    test "should get index" do
        get runcats_path(@sonic.slug)
        assert_response :success
        assert_select "title", "Categories for Sonic Mania | BoggyGoFast Speedrun Archive"
    end
end
