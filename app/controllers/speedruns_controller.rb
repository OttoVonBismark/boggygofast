class SpeedrunsController < ApplicationController

    before_action :admin_user,      only: [:edit, :update, :destroy]
    before_action :logged_in_user,  only: [:new, :create]

    def show
    end

    def new
        @speedrun = Speedrun.new
    end

    def create
    end

    def edit
    end

    def update
    end

    def destroy
    end

end
