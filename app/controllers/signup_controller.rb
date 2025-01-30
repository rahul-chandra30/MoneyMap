class SignupController < ApplicationController
  def index
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    Rails.logger.info "User Params: #{user_params.inspect}"
    if @user.save
      Rails.logger.info "User saved successfully"
      redirect_to signin_path, notice: 'User was successfully created. Please sign in.'
    else
      Rails.logger.error "User save failed: #{@user.errors.full_messages.join(", ")}"
      render :index
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :phone)
  end
end