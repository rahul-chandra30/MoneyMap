class ExpertsController < ApplicationController
  before_action :set_expert, only: [:update_profile]
  before_action :authenticate_expert!, except: [:new, :create, :login, :authenticate]

  def new
    @expert = Expert.new
  end

  def create
    @expert = Expert.new(expert_params)
    if @expert.save
      session[:expert_id] = @expert.id
      flash[:notice] = "Welcome to MoneyMap Expert Portal!"
      redirect_to expert_dashboard_path
    else
      flash.now[:alert] = "Sign-up failed: #{@expert.errors.full_messages.join(', ')}"
      render :new
    end
  end

  def login
  end

  def dashboard
    @expert = Expert.find_by(id: session[:expert_id])
    unless @expert
      flash[:alert] = "Please sign in as an expert"
      redirect_to expert_signin_path
    end
  end

  def authenticate
    expert = Expert.find_by(email: params[:email])
    if expert&.authenticate(params[:password])
      session[:expert_id] = expert.id
      flash[:notice] = "Welcome back, #{expert.name}!"
      redirect_to expert_dashboard_path and return
    else
      flash.now[:alert] = "Invalid email or password"
      render :login
    end
  end

  def logout
    session[:expert_id] = nil
    flash[:notice] = "Signed out successfully."
    redirect_to root_path
  end

  def update_profile
    if @expert.update(expert_params)
      flash[:notice] = "Profile updated successfully"
      redirect_to expert_dashboard_path
    else
      flash[:alert] = "Failed to update profile: #{@expert.errors.full_messages.join(', ')}"
      redirect_to expert_dashboard_path
    end
  end

  private

  def expert_params
    params.require(:expert).permit(
      :name, 
      :email, 
      :password, 
      :phone,
      :age,
      :gender,
      :experience,
      :designation,
      :charges_per_session,
      :about
    )
  end

  def set_expert
    @expert = Expert.find(session[:expert_id])
  end
end
