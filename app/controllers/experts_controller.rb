class ExpertsController < ApplicationController
  def new
    @expert = Expert.new
  end

  def create
    @expert = Expert.new(expert_params)
    if @expert.save
      session[:expert_id] = @expert.id
      flash[:notice] = "Sign-up successful! You are now logged in."
      redirect_to dashboard_path # Redirect to expert dashboard
    else
      flash[:alert] = "Sign-up failed. Please check the form."
      render :new
    end
  end

  def login
  end

  def dashboard
  @expert = Expert.find_by(id: session[:expert_id]) # Adjust based on authentication
  redirect_to signin_path, alert: "Please sign in" unless @expert
  end 

  def authenticate
    expert = Expert.find_by(email: params[:email])
    if expert && expert.authenticate(params[:password])
      session[:expert_id] = expert.id
      flash[:notice] = "Sign-in successful!"
      redirect_to expert_dashboard_path
    else
      flash[:alert] = "Invalid email or password."
      render :login
    end
  end

  def logout
    session[:expert_id] = nil
    flash[:notice] = "Signed out successfully."
    redirect_to root_path
  end

  private

  def expert_params
    params.require(:expert).permit(:name, :email, :password, :phone)
  end
end
