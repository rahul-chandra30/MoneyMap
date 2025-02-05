class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  add_flash_types :notice, :alert
 helper_method :current_user
  
  private
  
  def current_user
    @current_user ||= User.find_by(user_id: session[:user_id]) if session[:user_id]
  end
  
  def authenticate_user!
    unless current_user
      flash[:alert] = "Please sign in to access this page."
      redirect_to signin_path
    end
  end
end