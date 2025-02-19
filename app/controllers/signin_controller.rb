class SigninController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    expert = Expert.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      Rails.logger.debug "User authentication successful"
      session[:user_id] = user.id
      cookies.signed[:user_id] = user.id
      flash[:notice] = "Successfully signed in!"
      redirect_to dashboard_path
    elsif expert&.authenticate(params[:password])
      Rails.logger.debug "Expert authentication successful"
      session[:expert_id] = expert.id
      cookies.signed[:expert_id] = expert.id
      flash[:notice] = "Successfully signed in!"
      redirect_to expert_dashboard_path
    else
      Rails.logger.debug "Authentication failed"
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    session.delete(:expert_id)
    cookies.delete(:user_id)
    cookies.delete(:expert_id)
    redirect_to signin_path, notice: "Logged out successfully!"
  end
end
