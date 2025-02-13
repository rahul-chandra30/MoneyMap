class ExpertOpinionController < ApplicationController
  before_action :authenticate_user!

  def index
    @year = params[:year] || Time.current.year
    @month = params[:month] || Time.current.strftime("%B")
    @experts = Expert.all
  end
end