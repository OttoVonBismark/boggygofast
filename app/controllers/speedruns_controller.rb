class SpeedrunsController < ApplicationController
    before_action :admin_user,      only: [:edit, :destroy]
    before_action :logged_in_user,  only: [:new, :create]
    before_action :load_game

    def show
        @speedrun = Speedrun.find(params[:id])

        rcid = @speedrun.runcat_id
        @runcat = Runcat.find_by_id(rcid)
    end

    def index
    end

    def new
        @speedrun = Speedrun.new
    end

    def create
        @speedrun = @game.speedruns.new(speedrun_params)
        if @speedrun.save
            flash[:info] = "Run submitted successfully!"
            redirect_to root_url
        else
            render 'new'
        end 
    end

    def edit
        @speedrun = Speedrun.find(params[:id])
    end

    def update
        @speedrun = Speedrun.find(params[:id])
        if @speedrun.update_attributes(speedrun_params)
            flash[:success] = "Update successful"
            redirect_to @speedrun
        else
            render 'edit'
        end
    end

    def destroy
        @speedrun = Speedrun.find(params[:id])
        parent_index = speedruns_path(@speedrun.game.slug)
        @speedrun.destroy
        flash[:success] = "Run deleted successfully"
        redirect_to parent_index
    end

    def retrieve_runs_by_category(rcid)
        Speedrun.where('runcat_id == ?', rcid).to_a
    end



    private

    def speedrun_params
        params.require(:speedrun).permit(:date_finished, :runcat_id, :run_time, :run_notes, :is_valid,
                                         :game_id, :user_id, :run_time_h, :run_time_m, :run_time_s)
    end

end
