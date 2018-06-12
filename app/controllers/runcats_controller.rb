class RuncatsController < ApplicationController
    before_action :admin_user, only: [:new, :create, :destroy]
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
            redirect_to runcats_path
        else
            render 'new'
        end
    end

    # I can't seem to implement this without major bugs showing up including what I suspect to be a memory leak. We'll come back to this.
    # def edit
    # end

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
