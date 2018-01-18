class SpeedrunsController < ApplicationController
    before_action :admin_user,      only: [:edit, :update, :destroy]
    before_action :logged_in_user,  only: [:new, :create]

    def show
    end

    def index
        @speedruns = Speedrun.paginate(page: params[:page])
    end

    def new
        @speedrun = Speedrun.new
    end

    def create
        @speedrun = Speedrun.new(speedrun_params)
        if @speedrun.save
            flash[:info] = "Run submitted. It will appear once an admin has verified it."
            redirect_to games_index # Change this to the relevent game's leaderboard page later.
        else
            render 'new'
        end 
    end

    def edit
    end

    def update
        if @speedrun.update_attributes(speedrun_params)
            flash[:success] = "Update successful"
            redirect_to @speedrun
        else
            render 'edit'
        end
    end

    def destroy
        Speedrun.find(params[:id]).destroy
        flash[:success] = "Run deleted"
        redirect_to games_index # Update me
    end



    private

    def speedrun_params
        params.require(:speedrun).permit(:date_finished, :category, :run_time, :run_notes, :used_amiibo, :is_valid)
    end

end
