class SigninController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    
    if user&.authenticate(params[:password])
      Rails.logger.debug "Authentication successful"
      session[:user_id] = user.user_id 
      flash[:notice] = 'Successfully signed in!'
      redirect_to dashboard_path
    else
      Rails.logger.debug "Authentication failed"
      flash.now[:alert] = 'Invalid email or password.'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to signin_path, notice: 'Logged out successfully!'
  end
end
