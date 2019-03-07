class RuncatsController < ApplicationController
    before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]
    before_action :load_game

    def show
        @runcat = Runcat.find(params[:id])
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

    def edit
        @runcat = Runcat.find(params[:id])
    end

    def update
        @runcat = Runcat.find(params[:id])
        if @runcat.update_attributes(runcat_params)
            flash[:success] = "Update successful"
            redirect_to @runcat
        else
            render 'edit'
        end
    end

    def destroy
        Runcat.find(params[:id]).destroy
        flash[:success] = "Category deleted successfully"
        redirect_to runcats_path
    end



    private

    def runcat_params
        params.require(:runcat).permit(:category, :rules, :game_id)
    end
end
