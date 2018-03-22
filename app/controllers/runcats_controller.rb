class RuncatsController < ApplicationController
    before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]
    before_action :load_game

    def show
    end

    def index
    end

    def new
        @runcat = Runcat.new
    end

    def create
        @runcat = @game.runcats.new(runcat_params)
        if @runcat.save
            flash[:info] = "Category created successfully."
            redirect_to game_runcats
        else
            render 'new'
        end
    end

    def edit
    end

    def destroy
        Runcat.find(params[:id]).destroy
        flash[:success] = "Category deleted successfully"
        redirect_to game_runcats
    end



    private

    def runcat_params
        params.require(:runcat).permit(:category, :rules, :game_id)
    end
end
