class SigninController < ApplicationController
  def index
    # This will render the sign-in form
  end

  def create
    # Handle sign-in logic here
    # For now, just redirect to root_path
    redirect_to root_path, notice: 'Signed in successfully.'
  end

  def destroy
    # Handle sign-out logic here
    # For now, just redirect to root_path
    redirect_to root_path, notice: 'Signed out successfully.'
  end
end