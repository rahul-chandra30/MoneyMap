class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  add_flash_types :notice, :alert
  helper_method :current_user, :current_expert, :current_user_or_expert

  private

  # For Users
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authenticate_user!
    unless current_user
      flash[:alert] = "Please sign in to access this page."
      redirect_to signin_path
    end
  end

  # For Experts
  def current_expert
    @current_expert ||= Expert.find(session[:expert_id]) if session[:expert_id]
  end

  # For Experts
  def authenticate_expert!
    unless current_expert
      flash[:alert] = "Please sign in as an Expert to access this page."
      redirect_to signin_path
    end
  end

  def authenticate_user_or_expert!
    unless current_user || current_expert
      flash[:alert] = "Please sign in to access this page."
      redirect_to signin_path
    end
  end

  def ensure_user!
    unless current_user
      flash[:alert] = "This page is only accessible to users."
      redirect_to signin_path
    end
  end

  def ensure_expert!
    unless current_expert
      flash[:alert] = "This page is only accessible to experts."
      redirect_to signin_path
    end
  end

  def current_user_or_expert
    current_user || current_expert
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
