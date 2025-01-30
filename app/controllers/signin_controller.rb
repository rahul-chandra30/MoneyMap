class SigninController < ApplicationController
  def create
    # Log parameters
    Rails.logger.debug "Email: #{params[:email]}"
    Rails.logger.debug "Password: #{params[:password]}"

    # Step 1: Find the user
    user = User.find_by(email: params[:email])
    Rails.logger.debug "User found: #{user.inspect}"

    # Step 2: Authenticate
    if user&.authenticate(params[:password])
      Rails.logger.debug "Authentication successful"
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Successfully signed in!'
    else
      Rails.logger.debug "Authentication failed"
      flash.now[:alert] = 'Invalid email or password.'
      render :new
    end
  end
end
