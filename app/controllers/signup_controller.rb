class SignupController < ApplicationController
  def index
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to signin_path, notice: "Account created successfully! Please sign in."
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :phone)
  end
end
