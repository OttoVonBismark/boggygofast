class GamesController < ApplicationController

  before_action :admin_user,    only: [:new, :create, :edit, :update, :destroy]

  def index
    @games = Game.paginate(page: params[:page])
  end

  def show
    @game = Game.find_by_slug(params[:id])
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      flash[:info] = "Game added successfully. Using default CSS until you code otherwise."
      redirect_to games_index_url
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @game.update_attributes(game_params)
      flash[:success] = "Game updated"
      redirect_to games_url
    else
      render 'edit'
    end
  end

  def destroy
    Game.find(params[:slug]).destroy
    flash[:success] = "Game deleted successfully"
    redirect_to games_url
  end
  


  private

  def game_params
    params.require(:game).permit(:name, :slug)
  end
  
end
