class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper



  private

  # Redirects user to a 404 page.
  def render_404
    raise ActionController::RoutingError.new('404 Error. You seem to be lost, or the thing you wanted does not exist.')
  end

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in before you try that."
      redirect_to login_url
    end
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # Confirms an Admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
  
  # Retrieves game information for it's child controllers.
  def load_game
    @game = Game.find_by_slug(params[:slug])
  end
end
