class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      flash[:notice] = "Profile updated successfully."
      redirect_to dashboard_path
    else
      flash[:alert] = "Profile update failed."
      render :show
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :phone, :password, :password_confirmation)
  end
end