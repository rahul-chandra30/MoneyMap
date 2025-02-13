class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update]

  def show
    # Show user profile
    @user = current_user
  end

  def edit
    # Edit user profile
    @user = current_user
  end

  def update
    if @user.update(user_params)
      redirect_to profile_path, notice: 'Profile updated successfully'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :email, :phone)
  end
end