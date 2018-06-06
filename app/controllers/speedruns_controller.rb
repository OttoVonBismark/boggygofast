class SpeedrunsController < ApplicationController
    before_action :admin_user,      only: [:edit, :update, :destroy]
    before_action :logged_in_user,  only: [:new, :create]
    before_action :load_game

    def show
    end

    def index
    end

    def new
        @speedrun = Speedrun.new
    end

    def create
        @speedrun = @game.speedruns.new(speedrun_params)
        if @speedrun.save
            flash[:info] = "Run submitted. It will appear once an admin has verified it."
            redirect_to root_url
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

    def retrieve_runs_by_category(rcid)
        Speedrun.where('runcat_id == ?', rcid).to_a
        # Speedrun.find_by_sql([<<-SQL, runcat_id: cat]) 
        #   SELECT user_id, game_id, runcat_id, run_time_h, run_time_m, run_time_s, date_finished, run_notes FROM speedruns WHERE runcat_id = ?
        #     ORDER BY run_time_h ASC
        #     ORDER BY run_time_m ASC 
        #     ORDER BY run_time_s ASC
        #   SQL
    end



    private

    def speedrun_params
        params.require(:speedrun).permit(:date_finished, :runcat_id, :run_time, :run_notes, :is_valid,
                                         :game_id, :user_id, :run_time_h, :run_time_m, :run_time_s)
    end

end
