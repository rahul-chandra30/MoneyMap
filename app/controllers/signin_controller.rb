class SigninController < ApplicationController
  def new
  end

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
    flash.now[:alert] = 'Successfully signed in!'
    redirect_to dashboard_path
    else
      Rails.logger.debug "Authentication failed"
      flash.now[:alert] = 'Invalid email or password.'

      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("notifications", partial: "shared/notification") }
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to signin_path, notice: "Signed out successfully."
  end
end
